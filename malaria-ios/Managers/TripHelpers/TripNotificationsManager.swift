import Foundation
import UIKit

/// Manages trip notifications
class TripNotificationsManager : NotificationManager {
    /// Notification category
    override var category: String { get{ return "TripReminder"} }
    /// Notification alert body
    override var alertBody: String { get{ return "Don't forget to bring your items to the trip!"} }
    /// Notification alert action
    override var alertAction: String { get{ return "Got it!" } }
    
    private let trip: Trip
    
    /// Init
    init(trip: Trip){
        self.trip = trip
        super.init(context: trip.managedObjectContext!)
    }
}