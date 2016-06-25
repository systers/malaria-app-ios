import Foundation

/// Manages `Medicine` array of entries and provides useful methods to retrieve useful information
public class RegistriesManager: CoreDataContextManager{
  private let medicine: Medicine
  
  /// Init
  public init(medicine: Medicine){
    self.medicine = medicine
    super.init(context: medicine.managedObjectContext!)
  }
  
  /// Check if the pill was already taken in the period
  ///
  /// - parameter `NSDate`:: the date
  /// - parameter `[Registry]: optional`: Cached vector of entries, most recent first
  ///
  /// - returns: `Registry?`: registry
  public func tookMedicine(at: NSDate, registries: [Registry]? = nil) -> Registry?{
    let entries = allRegistriesInPeriod(at, registries: registries)
    if entries.noData {
      //Logger.Warn("No information available " + at.formatWith())
      return nil
    }
    
    for r in entries.entries{
      if r.tookMedicine{
        //Logger.Info("took medicine at " + at.formatWith())
        return r
      }
    }
    
    //Logger.Info("Did not take medicine at " + at.formatWith())
    return nil
  }
  
  /// Returns the list of entries that happens in the period of time
  ///
  /// - parameter `NSDate`:: the date
  /// - parameter `[Registry]: optional`: Cached vector of entries, most recent first
  ///
  /// - returns: `(noData: Bool, entries: [Registry])`: A tuple where the first value indicates if there are no entries
  /// before the date and the second the array of entries.
  public func allRegistriesInPeriod(at: NSDate, registries: [Registry]? = nil) -> (noData: Bool, entries: [Registry]){
    var result = [Registry]()
    
    let (day1, day2) = (at - (medicine.interval - 1).day, at + (medicine.interval - 1).day)
    
    var entries: [Registry] = []
    if let _ = registries {
      entries = filter(registries!, date1: day1, date2: day2)
    }else {
      entries = getRegistries(day1, date2: day2, mostRecentFirst: true)
    }
    
    if entries.count != 0 {
      let d1 = max(day1, entries.last!.date)
      let dateLimit = (d1 + (medicine.interval - 1).day).endOfDay
      
      for r in entries {
        if (r.date.sameDayAs(d1) || r.date > d1) && (r.date.sameDayAs(dateLimit) || r.date < dateLimit)  {
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
  
  /// Returns the most recent entry for that pill if there is
  ///
  /// - returns: `Registry?`
  public func mostRecentEntry() -> Registry?{
    return getRegistries().first
  }
  
  /// Returns the oldest entry for that pill if there is
  ///
  /// - returns: `Registry?`
  public func oldestEntry() -> Registry?{
    return getRegistries().last
  }
  
  /// Returns a tuple with the oldest and most recent entry
  ///
  /// - returns: `(leastRecent: Registry, mostRecent: Registry)?`
  public func getLimits() -> (leastRecent: Registry, mostRecent: Registry)? {
    let registries = getRegistries(mostRecentFirst: true)
    if let  mostRecent = registries.first,
      leastRecent = registries.last {
      
      return (leastRecent, mostRecent)
    }
    
    return nil
  }
  
  /// Adds a new entry for that pill
  ///
  /// It will return false if trying to add entries in the future
  /// If modifyEntry flag is set to false, It will return false it there is already an entry in the medicine interval
  ///
  /// If there is already an entry in the period and if modifyEntry is true, then the entry is deleted and replaced
  ///
  /// - parameter `NSDate`:: the date of the entry
  /// - parameter `Bool`:: if the user took medicine
  /// - parameter `Bool: optional`: overwrite previous entry (by default is false)
  ///
  /// - returns: `Bool`: true if there was a change, false if not
  public func addRegistry(date: NSDate, tookMedicine: Bool, modifyEntry: Bool = false) -> (registryAdded: Bool, noOtherEntryFound: Bool) {
    if date > NSDate() {
      Logger.Error("Cannot change entries in the future")
      return (false, true)
    }
    
    if let conflitingTookMedicineEntry = self.tookMedicine(date) {
      if tookMedicine && !modifyEntry && conflitingTookMedicineEntry.date.sameDayAs(date) {
        Logger.Warn("Found equivalent entry on same day")
        return (false, true)
      } else if modifyEntry {
        Logger.Warn("Removing confliting entry and replacing by a different one")
        
        //remove previous, whether it is weekly or daily (if daily we could just change the entry)
        removeEntry(conflitingTookMedicineEntry.date)
        
        //create new one
        let registry = Registry.create(Registry.self, context: context)
        registry.date = date
        registry.tookMedicine = tookMedicine
        
        var newRegistries: [Registry] = medicine.registries.convertToArray()
        newRegistries.append(registry)
        medicine.registries = NSSet(array: newRegistries)
        CoreDataHelper.sharedInstance.saveContext(context)
        NSNotificationEvents.DataUpdated(registry)
        
        return (true, true)
      }
      
      Logger.Warn("Can't modify entry on day " + date.formatWith() + " aborting")
      Logger.Warn("Confliting with " + conflitingTookMedicineEntry.date.formatWith())
      return (false, false)
    }
    
    //check if there is already a registry
    var registry : Registry? = findRegistry(date)
    
    if let r = registry{
      if r.tookMedicine && tookMedicine || !r.tookMedicine && !tookMedicine{
        Logger.Warn("Found equivalent entry")
        return (false, false)
      } else if !modifyEntry {
        Logger.Info("Can't modify entry. Aborting")
        return (false, true)
      }
      
      Logger.Info("Found entry same date. Modifying entry")
      r.tookMedicine = tookMedicine
      
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
    NSNotificationEvents.DataUpdated(registry!)
    
    return (true, true)
  }
  
  /// Returns entries between the two specified dates
  ///
  /// - parameter `NSDate`:: date1
  /// - parameter `NSDate`:: date2
  /// - parameter `Bool: optional`: if first element of result should be the most recent entry. (by default is true)
  /// - parameter `Bool: optional`: if true, it won't sort the elements reducing one sort cycle
  /// - parameter `(r:: Registry) -> Bool) optional`: Additional custom filter
  ///
  /// - returns: `[Registry]`
  public func getRegistries(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max, mostRecentFirst: Bool = true, unsorted: Bool = false, additionalFilter: ((r: Registry) -> Bool)? = nil) -> [Registry]{
    
    //make sure that date2 is always after date1
    if date1 > date2 {
      return getRegistries(date2, date2: date1, mostRecentFirst: mostRecentFirst)
    }
    
    //filter first then sort
    let entries: [Registry] = medicine.registries.convertToArray()
    let filtered = filter(entries, date1: date1, date2: date2, additionalFilter: additionalFilter)
    if unsorted {
      return filtered
    }
    return mostRecentFirst ? filtered.sort({$0.date > $1.date}) : filtered.sort({$0.date < $1.date})
  }
  
  /// Filter entries between two dates and, optionally, with an extra filter
  ///
  /// - parameter `[Registry]`:: list of entries
  /// - parameter `NSDate`:: first day
  /// - parameter `NSDate`:: second day
  /// - parameter `(r:: Registry) -> Bool) optional`: Additional custom filter
  /// - returns: `[Registry]`
  public func filter(registries: [Registry], date1: NSDate, date2: NSDate, additionalFilter: ((r: Registry) -> Bool)? = nil)  -> [Registry]{
    return registries.filter({ (additionalFilter?(r: $0) ?? true) &&
      (($0.date > date1 && $0.date < date2) ||
        $0.date.sameDayAs(date1) ||
        $0.date.sameDayAs(date2)) })
  }
  
  /// Returns entry in the specified date if exists
  ///
  /// - parameter `NSDate`:: date
  /// - parameter `[Registry]: optional`: Cached vector of entries, most recent first
  ///
  /// - returns: `Registry?`
  public func findRegistry(date: NSDate, registries: [Registry]? = nil) -> Registry?{
    if let r = registries {
      return filter(r, date1: date, date2: date).first
    }
    return getRegistries(date, date2: date, unsorted: true).first
  }
  
  /// Returns last day when the user taken the medicine
  ///
  /// :param `[Registry]? optional`: cached list of entries. Must be sorted from most recent to least recent
  ///
  /// - returns: `NSDate?`
  public func lastPillDate(registries: [Registry]? = nil) -> NSDate?{
    let entries = registries != nil ? registries! : getRegistries(mostRecentFirst: true)
    
    for r in entries{
      if r.tookMedicine{
        return r.date
      }
    }
    return nil
  }
  
  /// Remove the entry
  ///
  /// :param `Registry`: the entry to be removed
  public func removeEntry(date: NSDate){
    if let entry = findRegistry(date){
      
      let newRegistries: [Registry] = medicine.registries.convertToArray().filter({!$0.date.sameDayAs(date)})
      medicine.registries = NSSet(array: newRegistries)
      entry.deleteFromContext(context)
      CoreDataHelper.sharedInstance.saveContext(context)
      
      NSNotificationEvents.DataUpdated(nil)
    }else {
      Logger.Error("Removing entry: entry not found!!!")
    }
  }
}