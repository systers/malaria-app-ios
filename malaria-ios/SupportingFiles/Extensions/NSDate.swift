import Foundation

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func >(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedDescending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a === b || a.compare(b) == NSComparisonResult.OrderedSame
}


extension NSDate : Comparable {}

extension NSDate{
    
    /// NSDate(timeIntervalSince1970: 0)
    static var min: NSDate {
        return NSDate(timeIntervalSince1970: 0)
    }
    
    /// NSDate(timeIntervalSince1970: Double.infinity)
    static var max: NSDate{
        return NSDate(timeIntervalSince1970: Double.infinity)
    }
    
    /// Returns a new customized date
    ///
    /// By default, the hour will be set to 00:00
    ///
    /// :param: `Int`: Year.
    /// :param: `Int`: Month.
    /// :param: `Int`: Day.
    /// :param: `Int` optional: Hour.
    /// :param: `Int` optional: Minute.
    /// :returns: `NSDate`: Customized NSDate.
    class func from(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> NSDate {
        var c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute
        
        NSDate().formatWith("a")
        
        var gregorian = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        var date = gregorian!.dateFromComponents(c)
        return date!
    }
    
    /// Returns a string according in the format given by argumen
    ///
    /// :param: `String`: The format string (e.g. "yyyy-MM-dd")
    /// :returns: `String`
    func formatWith(format: String) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    /// Returns true if both dates represents the same day (day, month and year)
    ///
    /// :returns: `Bool`
    class func areDatesSameDay(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        var calender = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear
        var compOne: NSDateComponents = calender.components(flags, fromDate: dateOne)
        var compTwo: NSDateComponents = calender.components(flags, fromDate: dateTwo);
        return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year);
    }

    /// Returns true if both dates belong in the same week.
    ///
    /// :returns: `Bool`
    class func areDatesSameWeek(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let weekOfYear1 = calendar!.component(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: dateOne)
        let weekOfYear2 = calendar!.component(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: dateTwo)
        
        let year1 = calendar!.component(NSCalendarUnit.CalendarUnitYear, fromDate: dateOne)
        let year2 = calendar!.component(NSCalendarUnit.CalendarUnitYear, fromDate: dateTwo)
        
        return weekOfYear1 == weekOfYear2 && year1 == year2
    }
}


/// Returns number of days between 2 dates.
///
/// If first argument occurs before the second argument, the result will be a negative Integer
///
/// :param: `NSDate`: the first date.
/// :param: `NSDate`: the second date.
/// :returns: `Int`: number of days between date1 and date2.
public func - (toDate: NSDate, fromDate: NSDate) -> Int {
    var calendar: NSCalendar = NSCalendar.currentCalendar()
    
    // Replace the hour (time) of both dates with 00:00 to take into account different timezones
    let toDateNormalized = calendar.startOfDayForDate(toDate)
    let fromDateNormalized = calendar.startOfDayForDate(fromDate)
    
    let components = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate: fromDateNormalized, toDate: toDateNormalized, options: nil)
    
    return components.day
}