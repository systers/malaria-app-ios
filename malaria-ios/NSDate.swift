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
    
    static var min: NSDate {
        return NSDate(timeIntervalSince1970: 0)
    }
    
    static var max: NSDate{
        return NSDate(timeIntervalSince1970: Double.infinity)
    }
    
    class func from(year: Int, month: Int, day: Int) -> NSDate {
        var c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = 0
        c.minute = 0
        
        var gregorian = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        var date = gregorian!.dateFromComponents(c)
        return date!
    }
    
    func formatWith(format: String) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    
    
    class func areDatesSameDay(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        var calender = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear
        var compOne: NSDateComponents = calender.components(flags, fromDate: dateOne)
        var compTwo: NSDateComponents = calender.components(flags, fromDate: dateTwo);
        return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year);
    }

    class func areDatesSameWeek(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let weekOfYear1 = calendar!.component(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: dateOne)
        let weekOfYear2 = calendar!.component(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: dateTwo)
        
        let year1 = calendar!.component(NSCalendarUnit.CalendarUnitYear, fromDate: dateOne)
        let year2 = calendar!.component(NSCalendarUnit.CalendarUnitYear, fromDate: dateTwo)
        
        
        return weekOfYear1 == weekOfYear2 && year1 == year2
    }
}

public func - (toDate: NSDate, fromDate: NSDate) -> NSDateComponents {
    var calendar: NSCalendar = NSCalendar.currentCalendar()
    
    // Replace the hour (time) of both dates with 00:00 to take into account different timezones
    let toDateNormalized = calendar.startOfDayForDate(toDate)
    let fromDateNormalized = calendar.startOfDayForDate(fromDate)
    

    let components = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate: fromDateNormalized, toDate: toDateNormalized, options: nil)
    
    return components
}