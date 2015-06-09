import Foundation

extension Int{
    var day: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitDay)
    }
    
    var month: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitMonth)
    }
    
    var year: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitYear)
    }
}

public func + (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
    
    var components = NSDateComponents()
    
    components.setValue(tuple.value, forComponent: tuple.unit);
    
    return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))!
}

public func - (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
    var components = NSDateComponents()
    components.setValue(-(tuple.value), forComponent: tuple.unit);
    return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))!
}

public func += (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
    date = date + tuple
}

public func -= (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
    date = date - tuple
}