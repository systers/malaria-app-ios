import UIKit

class Constants {
  
  static let localNotificationsArray = "Local Notifications Array"
  static let DefaultBrownTint = UIColor(red: 118.0 / 255.0, green: 80.0 / 255.0, blue: 72.0 / 255.0, alpha: 1)
  static let DefaultGreenTint = UIColor(red: 133.0 / 255.0, green: 184.0 / 255.0, blue: 80.0 / 255.0, alpha: 1)
  
  struct Widget {
    static let BundleID = "anita-borg.pc-malaria-ios.pill-widget"
    static let DidTakePillForToday = "DidTakePillForToday"
    static let AppGroupBundleID = "group.anita-borg.pc-malaria-ios.took-pill"
    static let FirstRunFlag = "FirstRunFlag"
  }
  
  struct Storyboards {
    static let PillStats = "PillScreens"
    static let InfoHub = "InfoHub"
  }
  
  struct RapidFireGame {
    // How rapidly should the Remaining Seconds blink measured in seconds.
    static let RemainingSecondsBlinkRate = 0.2
  }
  
  struct Achievements {
    struct Tags {
      static let Pills = "Pills"
      static let Games = "Games"
      static let General = "General"
    }
    
    struct Pills {
      static let StayingSafe = "Staying safe"
    }
    
    struct RapidFireGame {
      static let FlawlessGame = "Flawless game"
    }
    
    struct General {
      static let PlanFirstTrip = "Plan First Trip"
    }
  }
}