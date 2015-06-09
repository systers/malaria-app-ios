import Foundation
import UIKit

class MedicineNotificationManager{
    static let sharedInstance = MedicineNotificationManager()
    
    
    
    let PillReminderCategory = "PillReminder"
    
    func scheduleNotification(medicine: Medicine.Pill, fireTime: NSDate){
        unsheduleNotification()
        
        let notification: UILocalNotification = createNotification(medicine.name(), fireDate: fireTime)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func unsheduleNotification(){
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == PillReminderCategory{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break;
            }
        }
    }
    
    func getFireDate() -> NSDate?{
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == PillReminderCategory{
                return notification.fireDate
            }
        }
        
        return nil
    }
    
    func reshedule() -> NSDate{
        //Empty for now but should generate smart notifications
        return NSDate()
    }
    

    //returns the number of supposed pills should have been taken
    private func createNotification(medicine: String, fireDate: NSDate) -> UILocalNotification{
        var localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = "Did you took the pill?"
        localNotification.alertBody = "\(medicine): Take me take me!"
        localNotification.alertAction = "Open"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = PillReminderCategory
        
        return localNotification
    }
}