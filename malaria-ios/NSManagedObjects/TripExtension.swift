import Foundation
import CoreData

extension Trip{
    var itemsManager: ItemsManager { get { return ItemsManager(trip: self) }}
    var notificationManager: TripNotificationsManager { get { return TripNotificationsManager(trip: self) }}
}
