import Foundation

extension Int{
    var day: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitDay)
    }
    
    var week: (Int, NSCalendarUnit) {
        return (self * 7, NSCalendarUnit.CalendarUnitDay)
    }
    
    var month: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitMonth)
    }
    
    var year: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitYear)
    }
    
    var minute: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitMinute)
    }
    
    var second: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitSecond)
    }
    
    var hour: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitHour)
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