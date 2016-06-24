import Foundation

/// Returns true if first argument happens before the second argument
/// - parameter `NSDate`:
/// - parameter `NSDate`::
///
/// - returns: `Bool`
public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

/// Returns true if first argument happens after the second argument
/// - parameter `NSDate`:
/// - parameter `NSDate`::
///
/// - returns: `Bool`
public func >(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedDescending
}

/// Returns true if first argument happens same time as the second argument
/// - parameter `NSDate`:
/// - parameter `NSDate`::
///
/// - returns: `Bool`
public func ==(a: NSDate, b: NSDate) -> Bool {
    return a === b || a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate : Comparable {}

public extension NSDate{
    
    ///retrieves the month
    public var month: Int {
        return NSCalendar.currentCalendar().component(.Month, fromDate: self)
    }
    
    ///retrieves the day
    public var day: Int {
        return NSCalendar.currentCalendar().component(.Day, fromDate: self)
    }
    
    ///retrieves the day of the week
    public var weekday: Int {
        return NSCalendar.currentCalendar().component(.Weekday, fromDate: self)
    }
    
    ///retrieves the year
    public var year: Int{
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: self)
    }
    
    ///retrieves the week
    public var week: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.WeekOfYear, fromDate: self)
    }
    
    ///retrieves the hour
    public var hour: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: self)
    }
    
    ///retrieves the minutes
    public var minutes: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: self)
    }
    
    ///retrieves the start day of the current month
    public var startOfCurrentMonth: NSDate{
        return NSDate.from(year, month: month, day: 1)
    }
    
    ///retrieves the end day of the current month
    public var endOfCurrentMonth: NSDate{
        return (NSDate.from(year, month: month, day: 1) + 1.month - 1.minute)
    }
    
    ///retrieves the start of the day (using startOfDayForDate)
    public var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
    
    ///retrieves the end of the day (23:59:59)
    public var endOfDay: NSDate {
        return startOfDay + 1.day - 1.second
    }
    
    /// retrieves the start of the week
    public var startOfWeek: NSDate {
        return (self - weekday.day).startOfDay
    }
    
    /// retrieves the end of the week
    public var endOfWeek: NSDate {
        return self.startOfWeek + 7.day - 1.minute
    }
    
    /// NSDate(timeIntervalSince1970: 0)
    public static var min: NSDate {
        return NSDate(timeIntervalSince1970: 0)
    }
    
    /// NSDate(timeIntervalSince1970: Double.infinity)
    public static var max: NSDate{
        return NSDate(timeIntervalSince1970: Double.infinity)
    }
    
    /// Returns a new customized date
    ///
    /// By default, the hour will be set to 00:00
    ///
    /// - parameter `Int`:: Year.
    /// - parameter `Int`:: Month.
    /// - parameter `Int`:: Day.
    /// - parameter `Int: optional`: Hour.
    /// - parameter `Int: optional`: Minute.
    ///
    /// - returns: `NSDate`: Customized NSDate.
    public static func from(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute
    
        return NSCalendar.currentCalendar().dateFromComponents(c)!
    }
    
    /// Returns a string according in the format given by argumen
    ///
    /// - parameter `String: optional`: default dd-MMMM-yyyy hh:mm
    ///
    /// - returns: `String`
    public func formatWith(format: String = "dd-MMMM-yyyy hh:mm") -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    /// Returns true if happens before the date given as argument
    ///
    /// - parameter `NSDate`:
    ///
    /// - returns: `Bool`
    public func happensMonthsBefore(date: NSDate) -> Bool{
        return (self.year < date.year) || (self.year == date.year && self.month < date.month)
    }
    
    /// Returns true if happens after the date given as argument
    ///
    /// - parameter `NSDate`:
    ///
    /// - returns: `Bool`
    public func happensMonthsAfter(date: NSDate) -> Bool{
        return (self.year > date.year) || (self.year == date.year && self.month > date.month)
    }
    
    /// Returns true if both dates represents the same day (day, month and year)
    /// - parameter `NSDate`:
    ///
    /// - returns: `Bool`
    public func sameDayAs(dateTwo: NSDate) -> Bool {
        return self.year == dateTwo.year && self.month == dateTwo.month && self.day == dateTwo.day
    }

    /// Returns true if both dates belong in the same week. Also takes into account year transition
    ///
    /// - parameter `NSDate`:
    ///
    /// - returns: `Bool`
    public func sameWeekAs(dateTwo: NSDate) -> Bool {
        return (self.year == dateTwo.year && self.week == dateTwo.week) || self.startOfWeek.sameDayAs(dateTwo.startOfWeek)
    }

    /// Returns true if both dates happens in the same month.
    ///
    /// - parameter `NSDate`:
    ///
    /// - returns: `Bool`
    public func sameMonthAs(dateTwo: NSDate) -> Bool {
        return (self.year == dateTwo.year && self.month == dateTwo.month)
    }
    
    /// Returns true if both dates are in the same time.
    ///
    /// - returns: `Bool`
    public func sameClockTimeAs(dateTwo: NSDate) -> Bool {
        return self.hour == dateTwo.hour && self.minutes == dateTwo.minutes
    }
}


/// Returns number of days between 2 dates.
///
/// If first argument occurs before the second argument, the result will be a negative Integer
///
/// - parameter `NSDate`:: the first date.
/// - parameter `NSDate`:: the second date.
/// - returns: `Int`: number of days between date1 and date2.
public func - (toDate: NSDate, fromDate: NSDate) -> Int {
    let calendar: NSCalendar = NSCalendar.currentCalendar()
    
    // Replace the hour (time) of both dates with 00:00 to take into account different timezones
    let toDateNormalized = calendar.startOfDayForDate(toDate)
    let fromDateNormalized = calendar.startOfDayForDate(fromDate)
    
    let components = calendar.components(.Day, fromDate: fromDateNormalized, toDate: toDateNormalized, options: [])
    
    return components.day
}