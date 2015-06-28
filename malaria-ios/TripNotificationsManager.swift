import Foundation
import UIKit

class TripNotificationsManager : NotificationManager{
    override var category: String { get{ return "TripReminder"} }

    var trip: Trip!
    
    init(trip: Trip){
        self.trip = trip
    }
    
    func scheduleNotification(fireTime: NSDate){
        unsheduleNotification()
        
        let notification: UILocalNotification = createNotification(fireTime, alertBody: "hello", alertAction: "double")
        super.scheduleNotification(notification)
        
        trip.reminderDate = fireTime
    }
}