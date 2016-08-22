/**
 Registry containing the date and boolean indicating if the user took
 the medicine on that day.
 */

import Foundation

class Registry: NSManagedObject {

  var date: NSDate {
    get {
      return NSDate(timeIntervalSinceReferenceDate: internalDate)
    }
    set {
      internalDate = newValue.timeIntervalSinceReferenceDate
    }
  }
}