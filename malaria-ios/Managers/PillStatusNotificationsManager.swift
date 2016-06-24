import UIKit
import Foundation

public class PillStatusNotificationsManager: NotificationManager {
  
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
  
  /// Notification category
  override public var category: String { get{ return "PillStatusReminder"} }
  
  /// Notification alert body
  override public var alertBody: String { get{ return "You ran out of pills!"} }
  
  /// Notification alert action
  override public var alertAction: String { get{ return "Ok" } }
    
  /// Schedules notification
  ///
  /// - parameter `NSDate`:: trigger time
  /// - parameter `completion`:: True is a notification was scheduled
  
  public func shouldPresentNotification(remainingPills: Int, reminderValue: Int) -> Bool {
    // Check if we don't have enough pills left
    return remainingPills < reminderValue
  }
  
  public override func scheduleNotification(fireTime: NSDate) {
    super.unsheduleNotification()
    super.scheduleNotification(fireTime)
  }
  
  /// Unschedule notification and sets the fireTime in medicine object as nil
  public override func unsheduleNotification(){
    super.unsheduleNotification()
  }
  
  /// Init
  init(context: NSManagedObjectContext) {
    super.init(context: context)
  }
}
