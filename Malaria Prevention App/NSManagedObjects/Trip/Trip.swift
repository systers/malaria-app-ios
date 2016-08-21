import CoreData

// Object that can be created by the user in the `PlanTripViewController`

class Trip: NSManagedObject {
  
  var arrival: NSDate {
    get {
      return NSDate(timeIntervalSinceReferenceDate: internalArrival)
    }
    set {
      internalArrival = newValue.timeIntervalSinceReferenceDate
    }
  }
  
  var departure: NSDate {
    get {
      return NSDate(timeIntervalSinceReferenceDate: internalDeparture)
    }
    set {
      internalDeparture = newValue.timeIntervalSinceReferenceDate
    }
  }
  
  var reminderTime: NSDate {
    get {
      return NSDate(timeIntervalSinceReferenceDate: internalReminderTime)
    }
    set {
      internalReminderTime = newValue.timeIntervalSinceReferenceDate
    }
  }
  
  /// Returns an object responsible for managing the items.
  
  var itemsManager: ItemsManager {
    return ItemsManager(trip: self)
  }
  
  /// Returns an object responsible for managing the notifications.
  
  var notificationManager: TripNotificationsManager {
    return TripNotificationsManager(trip: self)
  }
}