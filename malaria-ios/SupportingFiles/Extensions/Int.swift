import Foundation

public extension Int{
    /// :returns: (self, NSCalendarUnit.CalendarUnitday)
    public var day: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitDay)
    }
    
    /// :returns: (7 * self, CalendarUnitDay)
    public var week: (Int, NSCalendarUnit) {
        return (self * 7, NSCalendarUnit.CalendarUnitDay)
    }
    
    /// :returns: (self, CalendarUnitMonth)
    public var month: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitMonth)
    }
    
    /// :returns: (self, CalendarUnitYear)
    public var year: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitYear)
    }
    
    /// :returns: (self, CalendarUnitMinute)
    public var minute: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitMinute)
    }
    
    /// :returns: (self, CalendarUnitSecond)
    public var second: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitSecond)
    }
    
    /// :returns: (self, CalendarUnitHour)
    public var hour: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitHour)
    }
}

/// Adds calendar units to a NSDate instance
///
/// :param: `NSDate`: a date.
/// :param: `(Int, NSCalendarUnit)`: the time unit.
///
/// :returns: `NSDate`: the date added with the time unit given by argument.
public func + (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
    let components = NSDateComponents()
    components.setValue(tuple.value, forComponent: tuple.unit);
    
    return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))!
}

/// Adds calendar units to a NSDate instance
///
/// :param: `NSDate`: a date.
/// :param: `(Int, NSCalendarUnit)`: the time unit.
///
/// :returns: `NSDate`: the date subtracted with the time unit given by argument.
public func - (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
    return date + (-tuple.value, tuple.unit)
}

/// sugar-syntax for +
public func += (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
    date = date + tuple
}

/// sugar-syntax for -
public func -= (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
    date = date - tuple
}