import CoreData

/// Trip history class containing only the location.

class TripHistory: NSManagedObject {

  var timestamp: NSDate {
    get {
      return NSDate(timeIntervalSinceReferenceDate: internalTimestamp)
    }
    set {
      internalTimestamp = newValue.timeIntervalSinceReferenceDate
    }
  }
}
