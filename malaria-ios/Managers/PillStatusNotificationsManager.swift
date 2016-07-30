import UIKit
import Foundation

/// A class that handles setting notifications when the user runs out of pills.

class PillStatusNotificationsManager: NotificationManager {
  
  /// The current possible values of selecting an interval to be reminded
  /// of not having enough pills.
  
  enum ReminderInterval: Int {
    case FourDays  = 4
    case OneWeek   = 7
    case TwoWeeks  = 14
    case FourWeeks = 28
    
    func toString() -> String {
      switch self {
      case .FourDays: return "4 days"
      case .OneWeek: return "1 week"
      case .TwoWeeks: return "2 weeks"
      case .FourWeeks: return "4 weeks"
      }
    }
    
    static let allValues = [FourDays, OneWeek, TwoWeeks, FourWeeks]
  }
  
  /// Notification category.
  override var category: String { get{ return "PillStatusReminder"} }
  
  /// Notification alert body.
  override var alertBody: String { get{ return "You ran out of pills!"} }
  
  /// Notification alert action.
  override var alertAction: String { get{ return "Ok" } }
  
  /// A method that checks if the user has ran out of pills for their selected ReminderInterval.
  ///
  /// - parameter `remainingPills`:: Current user medicine stock.
  /// - parameter `reminderValue`:: The current number of days (represents in a number of pills)
  /// the user set in order to be reminded of.
  func shouldPresentNotification(remainingPills: Int, reminderValue: Int) -> Bool {
    return remainingPills < reminderValue
  }
  
  /// Schedules notification.
  ///
  /// - parameter `NSDate`:: trigger time.
  override func scheduleNotification(fireTime: NSDate) {
    super.unsheduleNotification()
    super.scheduleNotification(fireTime)
  }
  
  /// Unschedule notification.
  override func unsheduleNotification(){
    super.unsheduleNotification()
  }
  
  /// The init method of the PillStatusNotificationsManager.
  init(context: NSManagedObjectContext) {
    super.init(context: context)
  }
}
