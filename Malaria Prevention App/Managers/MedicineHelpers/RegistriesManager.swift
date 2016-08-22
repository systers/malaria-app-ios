import Foundation

/// Manages `Medicine` array of entries and provides useful methods to retrieve useful information.

class RegistriesManager: CoreDataContextManager {
  private let medicine: Medicine
  
  /// Init.
  init(medicine: Medicine) {
    self.medicine = medicine
    super.init(context: medicine.managedObjectContext!)
  }
  
  /**
   Check if the pill was already taken in the period.
   
   - parameter date: The date.
   - parameter registries: (optional) Cached vector of entries, most recent first.
   
   - returns: The Registry.
   */
  
  func tookMedicine(at: NSDate, registries: [Registry]? = nil) -> Registry? {
    let entries = allRegistriesInPeriod(at, registries: registries)
    if entries.noData {
      // Logger.Warn("No information available " + at.formatWith())
      return nil
    }
    
    for r in entries.entries {
      if r.tookMedicine{
        // Logger.Info("took medicine at " + at.formatWith())
        return r
      }
    }
    
    // Logger.Info("Did not take medicine at " + at.formatWith())
    return nil
  }
  
  /**
   Returns the list of entries that happens in the period of time.
   
   - parameter date: The date.
   - parameter registries: (optional) Cached vector of entries, most recent first.
   
   - returns: A tuple where the first value indicates if there are no entries
   before the date and the second the array of entries.
   */
  
  func allRegistriesInPeriod(at: NSDate, registries: [Registry]? = nil)
    -> (noData: Bool, entries: [Registry]) {
      var result = [Registry]()
      
      let (day1, day2) = (at - (medicine.interval - 1).day, at + (medicine.interval - 1).day)
      
      var entries: [Registry] = []
      if let _ = registries {
        entries = filter(registries!, date1: day1, date2: day2)
      } else {
        entries = getRegistries(day1, date2: day2, mostRecentFirst: true)
      }
      
      if entries.count != 0 {
        let d1 = max(day1, entries.last!.date)
        let dateLimit = (d1 + (medicine.interval - 1).day).endOfDay
        
        for r in entries {
          if (r.date.sameDayAs(d1) || r.date > d1)
            && (r.date.sameDayAs(dateLimit) || r.date < dateLimit)  {
            result.append(r)
          }
        }
        
        if at < d1 && !at.sameDayAs(d1) {
          return (true, result)
        }
        
        return (false, result)
      }
      
      return (true, result)
  }
  
  /**
   Returns the most recent entry for that pill if there is.
   
   - returns: The entry.
   */
  
  func mostRecentEntry() -> Registry? {
    return getRegistries().first
  }
  
  /**
   Returns the oldest entry for that pill if there is.
   
   - returns: The entry.
   */
  
  func oldestEntry() -> Registry? {
    return getRegistries().last
  }
  
  /**
   Returns a tuple with the oldest and most recent entry.
   
   - returns: A tuple with the least and most recent entries.
   */
  
  func getLimits() -> (leastRecent: Registry, mostRecent: Registry)? {
    let registries = getRegistries(mostRecentFirst: true)
    if let  mostRecent = registries.first,
      leastRecent = registries.last {
      
      return (leastRecent, mostRecent)
    }
    
    return nil
  }
  
  /**
   Adds a new entry for that pill.
   
   It will return false if trying to add entries in the future.
   If modifyEntry flag is set to false, It will return false it there is already an entry in the medicine interval.
   
   If there is already an entry in the period and if modifyEntry is true, then the entry is deleted and replaced.
   
   - parameter date: The date of the entry.
   - parameter tookMedicine: Indicating if the user took the medicine.
   - parameter modifyEntry: (optional) Overwrite previous entry (by default is false).
   
   - returns: A tuple with the first value indicating if the registry was added
   and the second value indicating if we did overwrite any other values
   (useful to know in operations on the calendar).
   */
  
  func addRegistry(date: NSDate, tookMedicine: Bool, modifyEntry: Bool = false)
    -> (registryAdded: Bool, otherEntriesFound: Bool) {
      if date > NSDate() {
        Logger.Error("Cannot change entries in the future")
        return (false, false)
      }
      
      if let conflitingTookMedicineEntry = self.tookMedicine(date) {
        
        if tookMedicine && !modifyEntry
          && conflitingTookMedicineEntry.date.sameDayAs(date) {
          
          Logger.Warn("Found equivalent entry on same day")
          return (false, true)
          
        } else if modifyEntry {
          Logger.Warn("Removing confliting entry and replacing by a different one")
          
          // Remove previous, whether it is weekly or daily
          // (if daily we could just change the entry).
          removeEntry(conflitingTookMedicineEntry.date)
          
          // Create new one.
          let registry = Registry.create(Registry.self, context: context)
          registry.date = date
          registry.tookMedicine = tookMedicine
          
          var newRegistries: [Registry] = medicine.registries.convertToArray()
          newRegistries.append(registry)
          medicine.registries = NSSet(array: newRegistries)
          CoreDataHelper.sharedInstance.saveContext(context)
          NSNotificationEvents.dataUpdated(registry)
          
          return (true, true)
        }
        
        Logger.Warn("Can't modify entry on day " + date.formatWith() + " aborting")
        Logger.Warn("Confliting with " + conflitingTookMedicineEntry.date.formatWith())
        return (false, false)
      }
      
      // Check if there is already a registry.
      var registry: Registry? = findRegistry(date)
      
      if let r = registry {
        if r.tookMedicine && tookMedicine || !r.tookMedicine && !tookMedicine {
          Logger.Warn("Found equivalent entry")
          return (false, true)
        } else if !modifyEntry {
          Logger.Info("Can't modify entry. Aborting")
          return (false, true)
        }
        
        Logger.Info("Found entry same date. Modifying entry")
        r.tookMedicine = tookMedicine
        
        CoreDataHelper.sharedInstance.saveContext(context)
        NSNotificationEvents.dataUpdated(registry)
        
        return (true, true)
      } else {
        Logger.Info("Adding entry on day: " + date.formatWith())
        registry = Registry.create(Registry.self, context: context)
        registry!.date = date
        registry!.tookMedicine = tookMedicine
        
        var newRegistries: [Registry] = medicine.registries.convertToArray()
        newRegistries.append(registry!)
        medicine.registries = NSSet(array: newRegistries)
      }
      
      CoreDataHelper.sharedInstance.saveContext(context)
      NSNotificationEvents.dataUpdated(registry)
      return (true, false)
  }
  
  /** Returns entries between the two specified dates.
   
   - parameter date1: The inferior limit date.
   - parameter date2: The superior limit date.
   - parameter mostRecentFirst: (optional) If first element of result should be the most recent entry (by default is true).
   - parameter unsorted: (optional) If true, it won't sort the elements reducing one sort cycle.
   - parameter additionalFilter: Additional custom filter.
   
   - returns: The registry.
   */
  
  func getRegistries(date1: NSDate = NSDate.min,
                     date2: NSDate = NSDate.max,
                     mostRecentFirst: Bool = true,
                     unsorted: Bool = false,
                     additionalFilter: ((r: Registry) -> Bool)? = nil) -> [Registry] {
    
    // Make sure that date2 is always after date1.
    if date1 > date2 {
      return getRegistries(date2, date2: date1, mostRecentFirst: mostRecentFirst)
    }
    
    // Filter first then sort.
    let entries: [Registry] = medicine.registries.convertToArray()
    let filtered = filter(entries, date1: date1, date2: date2, additionalFilter: additionalFilter)
    if unsorted {
      return filtered
    }
    return mostRecentFirst ? filtered.sort({$0.date > $1.date}) : filtered.sort({$0.date < $1.date})
  }
  
  /**
   Filter entries between two dates and, optionally, with an extra filter.
   
   - parameter registries: The list of entries.
   - parameter date1: The first day.
   - parameter date2: The second day.
   - parameter additionalFilter: Additional custom filter.
   
   - returns: The registry.
   */
  
  func filter(registries: [Registry],
              date1: NSDate,
              date2: NSDate,
              additionalFilter: ((r: Registry) -> Bool)? = nil) -> [Registry] {
    return registries.filter({ (additionalFilter?(r: $0) ?? true) &&
      (($0.date > date1 && $0.date < date2) ||
        $0.date.sameDayAs(date1) ||
        $0.date.sameDayAs(date2)) })
  }
  
  /**
   Returns entry in the specified date if exists.
   
   - parameter date: The date.
   - parameter registries: (optional) Cached vector of entries, most recent first.
   
   - returns: The registry.
   */
  
  func findRegistry(date: NSDate, registries: [Registry]? = nil) -> Registry? {
    if let r = registries {
      return filter(r, date1: date, date2: date).first
    }
    return getRegistries(date, date2: date, unsorted: true).first
  }
  
  /**
   Returns last day when the user taken the medicine.
   
   - parameter registries: (optional) Cached list of entries.
   Must be sorted from most recent to least recent.
   
   - returns: The last pill date.
   */
  
  func lastPillDate(registries: [Registry]? = nil) -> NSDate? {
    let entries = registries != nil ? registries! : getRegistries(mostRecentFirst: true)
    
    for r in entries {
      if r.tookMedicine {
        return r.date
      }
    }
    return nil
  }
  
  /**
   Remove the entry.
   
   - parameter date: The entry to be removed.
   */
  
  func removeEntry(date: NSDate) {
    if let entry = findRegistry(date) {
      
      let newRegistries: [Registry] = medicine.registries.convertToArray()
        .filter({!$0.date.sameDayAs(date)})
      
      medicine.registries = NSSet(array: newRegistries)
      entry.deleteFromContext(context)
      CoreDataHelper.sharedInstance.saveContext(context)
      
      NSNotificationEvents.dataUpdated(nil)
    } else {
      Logger.Error("Removing entry: entry not found!")
    }
  }
}