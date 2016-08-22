import Foundation

/// Responsible for generating statistics for medicine using `RegistriesManager`.

class MedicineStats : CoreDataContextManager {
  private let medicine: Medicine
  private let registriesManager: RegistriesManager
  
  /// Init.
  init(medicine: Medicine) {
    self.medicine = medicine
    registriesManager = self.medicine.registriesManager
    super.init(context: medicine.managedObjectContext!)
  }
  
  /**
   Returns the number of pills taken between two dates.
   
   - parameter date1: (optional) The first date (by default is NSDate.min).
   - parameter date2: (optional) The second date (by default is NSDate.max).
   - parameter registries: (optional) cached list of entries.
   
   - returns: The numbers of pills take in the interval.
   */
  
  func numberPillsTaken(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max, registries: [Registry]? = nil) -> Int {
    if let reg = registries {
      return reg.filter({$0.tookMedicine}).count
    }
    
    let filterTookMedicine = {(r: Registry) in return r.tookMedicine }
    return registriesManager.getRegistries(date1, date2: date2, unsorted: true, additionalFilter: filterTookMedicine).count
  }
  
  /**
   Returns the number of pills that the user should have taken between two dates.
   Uses static func numberNeededPills internally.
   
   - parameter date1: (optional) The first date (by default is NSDate.min).
   - parameter date2: (optional) The second date (by default is NSDate.max).
   - parameter registries: (optional) cached list of entries.
   
   - returns: The numbers of supposed pills to be taken in the interval.
   */
  
  func numberSupposedPills(date1: NSDate = NSDate.min,
                           date2: NSDate = NSDate.max,
                           registries: [Registry]? = nil) -> Int {
    if date1 > date2 {
      return numberSupposedPills(date2, date2: date1, registries: registries)
    }
    
    var d1 = date1
    var d2 = date2
    if date1 == NSDate.min || date2 == NSDate.max {
      if let r = registries {
        if let oldest = r.first,
          recent = r.last {
          d1 = d1 == NSDate.min ? oldest.date : d1
          d2 = d2 == NSDate.max ? recent.date : d2
        } else {
          return 0
        }
      } else {
        if let boundaries = registriesManager.getLimits() {
          d1 = d1 == NSDate.min ? boundaries.leastRecent.date : d1
          d2 = d2 == NSDate.max ? boundaries.mostRecent.date : d2
        } else {
          return 0
        }
      }
    }
    
    return MedicineStats.numberNeededPills(d1, date2: d2, interval: medicine.interval)
  }
  
  /**
   Returns the number of pills that the user should have taken between two dates.
   
   - parameter date1: (optional) The first date (by default is NSDate.min).
   - parameter date2: (optional) The second date (by default is NSDate.max).
   - parameter interval: Interval (1 = once per day, 7 = once per week).
   
   - returns: The number of supposed pills.
   */
  
  static func  numberNeededPills(date1: NSDate, date2: NSDate, interval: Int) -> Int{
    if date1 > date2 {
      return numberNeededPills(date2, date2: date1, interval: interval)
    }
    let numDays = (date2 - date1) + 1
    return  Int(ceil(Float(numDays) / Float(interval)))
  }
  
  /**
   Returns the number of pills that the user should have taken between two dates.
   
   Adherence = numberPillsTaken / SupposedPills.
   
   - parameter date1: (optional) The first date (by default is NSDate.min).
   - parameter date2: (optional) The second date (by default is NSDate.max).
   - parameter registries: (optional) cached list of entries.
   
   - returns: The Adherence.
   */
  
  func pillAdherence(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max,
                     registries: [Registry]? = nil) -> Float {
    let supposedPills = numberSupposedPills(date1, date2: date2, registries: registries)
    
    if supposedPills == 0 {
      return 1.0
    }
    
    let pillsTaken = numberPillsTaken(date1, date2: date2, registries: registries)
    
    return Float(pillsTaken)/(Float(supposedPills))
  }
  
  /**
   Returns the current Pill Streak of the user.
   
   If the user misses a day, the streak will be reset to 0
   
   - parameter date1: (optional) The first date (by default is NSDate.min).
   - parameter date2: (optional) The second date (by default is NSDate.max).
   - parameter registries: (optional) cached list of entries.
   Must be sorted from most recent to least recent.
   
   - returns: The pill streak.
   */
  
  func pillStreak(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max,
                  registries: [Registry]? = nil) -> Int {
    
    var entries: [Registry] = []
    if let r = registries{
      entries = r
    } else {
      entries = registriesManager.getRegistries(date1, date2: date2, mostRecentFirst: true)
    }
    
    var result = 0
    if !entries.isEmpty {
      var previousDate = date2 == NSDate.max ? entries.first!.date : date2
      for r in entries {
        //check for missing entries
        if r.date < previousDate - medicine.interval.day {
          return result
        }
        
        if r.tookMedicine {
          result += 1
        } else {
          return result
        }
        
        previousDate = r.date
      }
    }
    
    return result
  }
  
  /**
   Returns pill adhrence in a month.
   If there are no entries in that month return 0.
   Starts at max(oldest entry ; first day of the month).
   If current month, only goes up to today.
   If not, goes up to the mostRecentEntry.
   
   - parameter month: The month.
   - parameter currentday: (optional) Current day, default is NSDate.
   - parameter registries: Previously calculated entries. Must be sorted oldest to recent.
   
   - returns: The pill adherence for the month.
   */
  
  func monthAdherence(month: NSDate, currentDay: NSDate = NSDate(), registries: [Registry]? = nil) -> Float {
    let entries = registries != nil ? registries! : registriesManager.getRegistries(mostRecentFirst: false)
    
    if entries.count == 0 {
      return 1.0
    }
    
    let oldestDate = entries.first!.date
    
    let startMonth = NSDate.from(month.year, month: month.month, day: 1)
    let endMonth = month.endOfCurrentMonth
    
    if startMonth.happensMonthsBefore(oldestDate) {
      return 1.0
    }
    
    let day1 = max(startMonth, oldestDate)
    let day2 = endMonth.sameMonthAs(currentDay) ? min(endMonth, currentDay) : endMonth
    
    let filtered = registriesManager.filter(entries, date1: day1, date2: day2)
    return pillAdherence(day1, date2: day2, registries: filtered)
  }
}