import UIKit

class Constants {
  
  struct Widget {
    static let BundleID = "anita-borg.pc-malaria-ios.pill-widget"
    static let DidTakePillForToday = "DidTakePillForToday"
    static let AppGroupBundleID = "group.anita-borg.pc-malaria-ios.took-pill"
    static let FirstRunFlag = "FirstRunFlag"
    
    // User Profile
    static let RemainingPills = "Remaining Pills Constant"
    static let RemainingPillsUnitMeasure = "Remaining Pills Unit Measure Constant"
  }
  
  struct UserProfile {
    static let CellReuseIdentifier = "User Profile Pill Cell Identifier"
    static let PillReminderValue = "Pill Reminder Value"
    
    // We found a problem that didn't allow us to click on the table view's cell if we only set the cell
    // height (60) and not add ~30-50 offset to it
    static let CellHeightAndOffset: CGFloat = 60 + 30
  }
  
  static let localNotificationsArray = "Local Notifications Array"
}
