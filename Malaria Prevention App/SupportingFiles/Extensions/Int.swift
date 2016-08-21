import Foundation

extension Int {
  
  /// - returns: (self, NSCalendarUnit.CalendarUnitday)
  
  var day: (Int, NSCalendarUnit) {
    return (self, NSCalendarUnit.Day)
  }
  
  /// - returns: (7 * self, CalendarUnitDay)
  
  var week: (Int, NSCalendarUnit) {
    return (self * 7, NSCalendarUnit.Day)
  }
  
  /// - returns: (self, CalendarUnitMonth)
  
  var month: (Int, NSCalendarUnit) {
    return (self, NSCalendarUnit.Month)
  }
  
  /// - returns: (self, CalendarUnitYear)
  
  var year: (Int, NSCalendarUnit) {
    return (self, NSCalendarUnit.Year)
  }
  
  /// - returns: (self, CalendarUnitMinute)
  
  var minute: (Int, NSCalendarUnit) {
    return (self, NSCalendarUnit.Minute)
  }
  
  /// - returns: (self, CalendarUnitSecond)
  
  var second: (Int, NSCalendarUnit) {
    return (self, NSCalendarUnit.Second)
  }
  
  /// - returns: (self, CalendarUnitHour)
  
  var hour: (Int, NSCalendarUnit) {
    return (self, NSCalendarUnit.Hour)
  }
}

/**
 Adds calendar units to a NSDate instance
 
 - parameter date: A date.
 - parameter (value, unit): The time unit.
 
 - returns: The date added with the time unit given by argument.
 */

func + (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
  let components = NSDateComponents()
  components.setValue(tuple.value, forComponent: tuple.unit);
  
  return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
}

/**
 Adds calendar units to a NSDate instance
 
 - parameter date: The date.
 - parameter (value, unit): The time unit.
 
 - returns: The date subtracted with the time unit given by argument.
 */

func - (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
  return date + (-tuple.value, tuple.unit)
}

/// sugar-syntax for +

func += (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
  date = date + tuple
}

/// sugar-syntax for -

func -= (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
  date = date - tuple
}