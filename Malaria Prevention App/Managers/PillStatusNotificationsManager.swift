import UIKit
import Foundation

/// A class that handles setting notifications when the user runs out of pills.

class PillStatusNotificationsManager: NotificationManager {
  
  /**
   The current possible values of selecting an interval to be reminded
   of not having enough pills.
   */
  
  enum ReminderInterval: Int {
    case fourDays  = 4
    case oneWeek   = 7
    case twoWeeks  = 14
    case fourWeeks = 28
    
    func toString() -> String {
      
      switch self {
      case .fourDays: return "4 " + NSLocalizedString("days", comment: "")
      case .oneWeek: return "1 " + NSLocalizedString("week", comment: "")
      case .twoWeeks: return "2 " + NSLocalizedString("weeks", comment: "")
      case .fourWeeks: return "4 " + NSLocalizedString("weeks", comment: "")
      }
    }
    
    static let allValues = [fourDays, oneWeek, twoWeeks, fourWeeks]
  }
  
  /// Notification category.
  
  override var category: String { return "PillStatusReminder"}
  
  /// Notification alert body.
  
  override var alertBody: String { return NSLocalizedString("You ran out of pills!", comment: "") }
  
  /// Notification alert action.
  
  override var alertAction: String { return NSLocalizedString("Ok", comment: "") }
  
  /**
   A method that checks if the user has ran out of pills for their selected `ReminderInterval`.
   
   - parameter remainingPills: Current user medicine stock.
   - parameter reminderValue: The current number of days (represents in a number of pills)
   the user set in order to be reminded of.
   
   - returns:  A boolean regarding wheter the user has enough pills based on the set interval.
   */
  
  func shouldPresentNotification(remainingPills: Int, reminderValue: Int) -> Bool {
    return remainingPills < reminderValue
  }
  
  /**
   Schedules notification.
   
   - parameter fireTime: trigger time.
   */
  
  override func scheduleNotification(fireTime: NSDate) {
    super.unsheduleNotification()
    super.scheduleNotification(fireTime)
  }
  
  /// Unschedule notification.
  
  override func unsheduleNotification() {
    super.unsheduleNotification()
  }
  
  /// The init method of the PillStatusNotificationsManager.
  
  init(context: NSManagedObjectContext) {
    super.init(context: context)
  }
}