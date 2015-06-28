import Foundation

extension Int{
    /// :returns: (self, NSCalendarUnit.CalendarUnitday)
    var day: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitDay)
    }
    
    /// :returns: (7 * self, CalendarUnitDay)
    var week: (Int, NSCalendarUnit) {
        return (self * 7, NSCalendarUnit.CalendarUnitDay)
    }
    
    /// :returns: (self, CalendarUnitMonth)
    var month: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitMonth)
    }
    
    /// :returns: (self, CalendarUnitYear)
    var year: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitYear)
    }
    
    /// :returns: (self, CalendarUnitMinute)
    var minute: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitMinute)
    }
    
    /// :returns: (self, CalendarUnitSecond)
    var second: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitSecond)
    }
    
    /// :returns: (self, CalendarUnitHour)
    var hour: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitHour)
    }
}

/// Adds calendar units to a NSDate instance
///
/// :param: `NSDate`: a date.
/// :param: `(Int, NSCalendarUnit)`: the time unit.
/// :returns: `NSDate`: the date added with the time unit given by argument.
public func + (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
    var components = NSDateComponents()
    components.setValue(tuple.value, forComponent: tuple.unit);
    
    
    return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))!
}

/// Adds calendar units to a NSDate instance
///
/// :param: `NSDate`: a date.
/// :param: `(Int, NSCalendarUnit)`: the time unit.
/// :returns: `NSDate`: the date subtracted with the time unit given by argument.
public func - (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
    var components = NSDateComponents()
    components.setValue(-(tuple.value), forComponent: tuple.unit);
    return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))!
}

public func += (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
    NSDate() - NSDate()

    date = date + tuple
}

public func -= (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
    date = date - tuple
}