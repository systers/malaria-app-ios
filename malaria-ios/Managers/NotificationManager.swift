import Foundation
import UIKit

/// Abstract class for handling `UILocalNotification`
public class NotificationManager : CoreDataContextManager{
  /// Alert category, default fatalError
  public var category: String { get{ fatalError("No category provided")} }
  
  /// Alert body, default fatalError
  public var alertBody: String { get{ fatalError("No alertBody provided")} }
  
  /// Alert action, default fatalError
  public var alertAction: String { get{ fatalError("No alertAction provided")} }
  
  override public init(context: NSManagedObjectContext!){
    super.init(context: context)
  }
  
  private var scheduledNotifications = [UILocalNotification]()
  
  /// Schedule a notification at the fireTime given by argument
  ///
  /// All previous notifications will be unsheduled
  ///
  /// - parameter `NSDate`:: fireTime
  public func scheduleNotification(fireTime: NSDate){
    Logger.Info("Sheduling \(category) to " + fireTime.formatWith("dd-MMMM-yyyy hh:mm"))
    let notification: UILocalNotification = createNotification(fireTime)
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }
  
  /// Unschedule all notifications with the category
  public func unsheduleNotification(){
    //        for event in UIApplication.sharedApplication().scheduledLocalNotifications!
    //          where event.category == category {
    //                UIApplication.sharedApplication().cancelLocalNotification(event)
    //        }
    
    let localNotificationArrayData = NSUserDefaults.standardUserDefaults().objectForKey(Constants.localNotificationsArray) as? NSData
    
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
  
  /// Creates a notification
  ///
  /// - parameter `NSDate`:: fireTime
  /// - returns: `UILocalNotification`: local notification
  private func createNotification(fireDate: NSDate) -> UILocalNotification{
    let localNotification = UILocalNotification()
    localNotification.fireDate = fireDate
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = alertAction
    localNotification.alertBody = alertBody
    localNotification.soundName = UILocalNotificationDefaultSoundName
    localNotification.category = category
    
    scheduledNotifications.append(localNotification)
    
    // Save the notifications persistently
    let localNotificationArrayData = NSKeyedArchiver.archivedDataWithRootObject(scheduledNotifications)
    NSUserDefaults.standardUserDefaults().setObject(localNotificationArrayData, forKey: Constants.localNotificationsArray)
    
    return localNotification
  }
}