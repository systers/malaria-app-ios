import CoreData

extension Trip {
  
    /// Returns an object responsible for managing the items.
    var itemsManager: ItemsManager {
        return ItemsManager(trip: self)
    }
    
    /// Returns an object responsible for managing the notifications.
    var notificationManager: TripNotificationsManager {
        return TripNotificationsManager(trip: self)
    }
}
