import Foundation
import UIKit

/// Abstract class for handling `UILocalNotification`.

class NotificationManager: CoreDataContextManager {
  
  /// Alert category, default fatalError.
  var category: String { fatalError("No category provided") }
  
  /// Alert body, default fatalError.
  var alertBody: String { fatalError("No alertBody provided") }
  
  /// Alert action, default fatalError.
  var alertAction: String { fatalError("No alertAction provided") }
  
  override init(context: NSManagedObjectContext!) {
    super.init(context: context)
  }
  
  private var scheduledNotifications = [UILocalNotification]()
  
  /**
   Schedule a notification at the `fireTime` given by argument.
   
   All previous notifications will be unsheduled.
   
   - parameter fireTime: The date when the notification will show.
   */
  
  func scheduleNotification(fireTime: NSDate) {
    
    if fireTime < NSDate() && !fireTime.sameDayAs(NSDate()) {
      return
    }
    
    Logger.Info("Sheduling \(category) to " + fireTime.formatWith("dd-MMMM-yyyy hh:mm"))
    let notification: UILocalNotification = createNotification(fireTime)
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }
  
  /// Unschedule all notifications with the category.
  
  func unsheduleNotification() {
    let localNotificationArrayData = UserSettingsManager.UserSetting.saveLocalNotifications.getLocalNotifications()
    
    guard let data = localNotificationArrayData else {
      return
    }
    
    let scheduledNotifications = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [UILocalNotification]
        
    guard let notifications = scheduledNotifications else {
      return
    }
    
    for notification in notifications
      where notification.category == category {
        UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
  }
  
  /**
   Creates a notification
   
   - parameter fireDate: The date when the notification will show.
   
   - returns: The local notification.
   */
  
  private func createNotification(fireDate: NSDate) -> UILocalNotification {
    let localNotification = UILocalNotification()
    localNotification.fireDate = fireDate
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = alertAction
    localNotification.alertBody = alertBody
    localNotification.soundName = UILocalNotificationDefaultSoundName
    localNotification.category = category
    
    scheduledNotifications.append(localNotification)
    
    // Save the notifications persistently.
    let localNotificationArrayData = NSKeyedArchiver.archivedDataWithRootObject(scheduledNotifications)
    UserSettingsManager.UserSetting.saveLocalNotifications.setLocalNotifications(localNotificationArrayData)
    
    return localNotification
  }
}