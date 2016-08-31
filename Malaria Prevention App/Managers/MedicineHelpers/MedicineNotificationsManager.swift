import Foundation
import UIKit

/// Manages notifications for medicine.

class MedicineNotificationsManager: NotificationManager {
  
  /// Notification category.
  
  override var category: String { return MedicineNotificationsManager.NotificationCategory }
  
  /// Notification alert body.
  
  override var alertBody: String {
    let medicineName = MedicineManager(context: context).getCurrentMedicine()!.name
    
    let localizedString = String.localizedStringWithFormat(
      NSLocalizedString("Did you take %@ today?", comment: ""), medicineName)
    return localizedString
  }
  
  /// Notification alert action.
  override var alertAction: String { return "Take pill" }
  
  private let medicine: Medicine
  
  /// If for Yes in interactive notifications.
  static let TookPillId = "TookPill"
  
  /// Yes action string for interactive notifications.
  static let TookPillTitle = "Yes"
  
  /// Id for No in interactive notifications.
  static let DidNotTakePillId = "DidNotTakePillId"
  
  /// No action string for interactive notifications.
  static let DidNotTakePillTitle = "No"
  
  /// Notification's category.
  static let NotificationCategory = "PILL_REMINDER"
  
  /// Init
  
  init(medicine: Medicine) {
    self.medicine = medicine
    super.init(context: medicine.managedObjectContext!)
  }
  
  /**
   Schedule notification and stores the fireTime in the medicine object.
   
   - parameter fireTime: Trigger time.
   */
  
  override func scheduleNotification(fireTime: NSDate) {
    medicine.notificationTime = fireTime
    CoreDataHelper.sharedInstance.saveContext(self.context)
    super.unsheduleNotification()
    super.scheduleNotification(fireTime)
  }
  
  /// Unschedule notification and sets the fireTime in medicine object as nil.
  
  override func unsheduleNotification() {
    super.unsheduleNotification()
    
    medicine.notificationTime = nil
    CoreDataHelper.sharedInstance.saveContext(self.context)
  }
  
  /**
   Reschedule the pill according to the medicine interval
   So, if on monday, 1/1/2014, and interval is 4 days then
   it will resheduled to (1 + 4) / 1 / 2014.
   
   - returns: The new reminder time.
   */
  
  func reshedule() -> NSDate? {
    if var nextTime = medicine.notificationTime {
      nextTime += medicine.interval.day
      medicine.notificationTime = nextTime
      
      unsheduleNotification()
      scheduleNotification(nextTime)
      
      return nextTime
    }
    
    return nil
  }
  
  /**
   Returns interactive notifications settings to be added in the AppDelegate.
   
   - returns: The configuration.
   */
  
  static func setup() -> UIMutableUserNotificationCategory {
    let notificationActionOk = UIMutableUserNotificationAction()
    notificationActionOk.identifier = TookPillId
    notificationActionOk.title = TookPillTitle
    notificationActionOk.destructive = false
    notificationActionOk.authenticationRequired = false
    notificationActionOk.activationMode = .Background
    
    let notificationActionCancel = UIMutableUserNotificationAction()
    notificationActionCancel.identifier = DidNotTakePillId
    notificationActionCancel.title = DidNotTakePillTitle
    notificationActionCancel.destructive = true
    notificationActionCancel.authenticationRequired = false
    notificationActionCancel.activationMode = .Background
    
    let notificationCategory = UIMutableUserNotificationCategory()
    notificationCategory.identifier = NotificationCategory
    notificationCategory.setActions([notificationActionOk, notificationActionCancel], forContext: .Default)
    notificationCategory.setActions([notificationActionOk, notificationActionCancel], forContext: .Minimal)
    
    return notificationCategory
  }
}