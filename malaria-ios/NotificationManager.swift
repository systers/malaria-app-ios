import Foundation

class NotificationManager{

    var category: String { get{ fatalError("No category provided")} }

    func scheduleNotification(notification: UILocalNotification){
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func unsheduleNotification(){
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == category{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break;
            }
        }
    }
    
    //returns the number of supposed pills should have been taken
    func createNotification(fireDate: NSDate, alertBody: String, alertAction: String) -> UILocalNotification{
        var localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = alertAction
        localNotification.alertBody = alertBody
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = category
        
        return localNotification
    }
}