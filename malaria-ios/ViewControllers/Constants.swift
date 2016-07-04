import UIKit

class Constants {
  
  struct Widget {
    static let BundleID = "anita-borg.pc-malaria-ios.pill-widget"
    static let DidTakePillForToday = "DidTakePillForToday"
    static let AppGroupBundleID = "group.anita-borg.pc-malaria-ios.took-pill"
    static let FirstRunFlag = "FirstRunFlag"
  }
  
  static let localNotificationsArray = "Local Notifications Array"
  
  struct Storyboards {
    
    static let PillStats = "PillScreens"
    static let InfoHub = "InfoHub"
  }
  
  struct RapidFireGame {
    
    // How rapidly should the Remaining Seconds blink
    // measured in seconds.
    static let RemainingSecondsBlinkRate = 0.2
  }
}
