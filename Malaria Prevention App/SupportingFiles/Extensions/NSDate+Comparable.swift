import Foundation

/**
 Returns true if first argument happens before the second argument.
 
 - parameter a: The first date.
 - parameter b: The second date.
 
 - returns: The result.
 */

public func <(a: NSDate, b: NSDate) -> Bool {
  return a.compare(b) == NSComparisonResult.OrderedAscending
}

/**
 Returns true if first argument happens after the second argument.
 
 - parameter a: The first date.
 - parameter b: The second date.
 
 - returns: The result.
 */

public func >(a: NSDate, b: NSDate) -> Bool {
  return a.compare(b) == NSComparisonResult.OrderedDescending
}

/**
 Returns true if first argument happens same time as the second argument.
 
 - parameter a: The first date.
 - parameter b: The second date.
 
 - returns: The result.
 */

func ==(a: NSDate, b: NSDate) -> Bool {
  return a === b || a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate {
  
  /// Retrieves the month.
  var month: Int {
    return NSCalendar.currentCalendar().component(.Month, fromDate: self)
  }
  
  /// Retrieves the day.
  var day: Int {
    return NSCalendar.currentCalendar().component(.Day, fromDate: self)
  }
  
  /// Retrieves the day of the week.
  var weekday: Int {
    return NSCalendar.currentCalendar().component(.Weekday, fromDate: self)
  }
  
  /// Retrieves the year.
  var year: Int {
    return NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: self)
  }
  
  /// Retrieves the week.
  var week: Int {
    return NSCalendar.currentCalendar().component(NSCalendarUnit.WeekOfYear, fromDate: self)
  }
  
  /// Retrieves the hour.
  var hour: Int {
    return NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: self)
  }
  
  /// Retrieves the minutes.
  var minutes: Int {
    return NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: self)
  }
  
  /// Retrieves the start day of the current month.
  var startOfCurrentMonth: NSDate{
    return NSDate.from(year, month: month, day: 1)
  }
  
  /// Retrieves the end day of the current month.
  var endOfCurrentMonth: NSDate{
    return (NSDate.from(year, month: month, day: 1) + 1.month - 1.minute)
  }
  
  /// Retrieves the start of the day (using startOfDayForDate).
  var startOfDay: NSDate {
    return NSCalendar.currentCalendar().startOfDayForDate(self)
  }
  
  /// Retrieves the end of the day (23:59:59).
  var endOfDay: NSDate {
    return startOfDay + 1.day - 1.second
  }
  
  /// Retrieves the start of the week.
  var startOfWeek: NSDate {
    return (self - weekday.day).startOfDay
  }
  
  /// Retrieves the end of the week.
  var endOfWeek: NSDate {
    return self.startOfWeek + 7.day - 1.minute
  }
  
  /// NSDate(timeIntervalSince1970: 0).
  static var min: NSDate {
    return NSDate(timeIntervalSince1970: 0)
  }
  
  /// NSDate(timeIntervalSince1970: Double.infinity).
  static var max: NSDate {
    return NSDate(timeIntervalSince1970: Double.infinity)
  }
  
  /**
   Returns a new customized date.
   By default, the hour will be set to 00:00.
   
   - parameter year: Year.
   - parameter month: Month.
   - parameter day: Day.
   - parameter hour: (optional) Hour.
   - parameter minute: (optional) Minute.
   
   - returns: Customized NSDate.
   */
  
  static func from(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> NSDate {
    let c = NSDateComponents()
    c.year = year
    c.month = month
    c.day = day
    c.hour = hour
    c.minute = minute
    
    return NSCalendar.currentCalendar().dateFromComponents(c)!
  }
  
  /**
   Returns a string according in the format given by argument.
   
   - parameter format: Default `dd-MMMM-yyyy hh:mm`.
   
   - returns: The new string.
   */
  
  func formatWith(format: String = "dd-MMMM-yyyy hh:mm") -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = format
    return formatter.stringFromDate(self)
  }
  
  /** Returns true if happens before the date given as argument.
   
   - parameter date: The date.
   
   - returns: The result.
   */
  
  func happensMonthsBefore(date: NSDate) -> Bool {
    return (self.year < date.year) || (self.year == date.year && self.month < date.month)
  }
  
  /**
   Returns true if happens after the date given as argument.
   
   - parameter date: The date.
   
   - returns: The result.
   */
  
  func happensMonthsAfter(date: NSDate) -> Bool{
    return (self.year > date.year) || (self.year == date.year && self.month > date.month)
  }
  
  /**
   Returns true if both dates represents the same day (day, month and year).
   
   - parameter date: The date.
   
   - returns: The result.
   */
  
  func sameDayAs(dateTwo: NSDate) -> Bool {
    return self.year == dateTwo.year && self.month == dateTwo.month && self.day == dateTwo.day
  }
  
  /**
   Returns true if both dates belong in the same week. Also takes into account year transition.
   
   - parameter date: The date.
   
   - returns: The result.
   */
  
  func sameWeekAs(dateTwo: NSDate) -> Bool {
    return (self.year == dateTwo.year && self.week == dateTwo.week) || self.startOfWeek.sameDayAs(dateTwo.startOfWeek)
  }
  
  /**
   Returns true if both dates happens in the same month.
   
   - parameter date: The date.
   
   - returns: The result.
   */
  
  func sameMonthAs(dateTwo: NSDate) -> Bool {
    return (self.year == dateTwo.year && self.month == dateTwo.month)
  }
  
  /**
   Returns true if both dates are in the same time.
   
   - returns: The result.
   */
  
  func sameClockTimeAs(dateTwo: NSDate) -> Bool {
    return self.hour == dateTwo.hour && self.minutes == dateTwo.minutes
  }
}

/**
 Returns number of days between 2 dates.
 
 If first argument occurs before the second argument, the result will be a negative Integer
 
 - parameter toDate: The first date.
 - parameter fromDate: The second date.
 - returns: The number of days between `toDate` and `fromDate`.
 */

func - (toDate: NSDate, fromDate: NSDate) -> Int {
  let calendar: NSCalendar = NSCalendar.currentCalendar()
  
  // Replace the hour (time) of both dates with 00:00 to take into account different timezones.
  let toDateNormalized = calendar.startOfDayForDate(toDate)
  let fromDateNormalized = calendar.startOfDayForDate(fromDate)
  
  let components = calendar.components(.Day, fromDate: fromDateNormalized, toDate: toDateNormalized, options: [])
  
  return components.day
}