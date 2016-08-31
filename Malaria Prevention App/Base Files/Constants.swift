import UIKit

class Constants {
  
  static let DefaultBrownTint = UIColor(red: 118.0 / 255.0, green: 80.0 / 255.0, blue: 72.0 / 255.0, alpha: 1)
  static let DefaultGreenTint = UIColor(red: 133.0 / 255.0, green: 184.0 / 255.0, blue: 80.0 / 255.0, alpha: 1)
  
  struct Widget {
    static let BundleID = "anita-borg.pc-malaria-ios.pill-widget"
    static let didTakePillForToday = "didTakePillForToday"
    static let AppGroupBundleID = "group.anita-borg.pc-malaria-ios.took-pill"
    static let FirstRunFlag = "FirstRunFlag"
  }
  
  struct Storyboards {
    static let PillStats = "PillScreens"
    static let InfoHub = "InfoHub"
    static let InitialSetup = "InitialSetup"
  }
  
  struct Achievements {
    static let GeneralTag = NSLocalizedString("General",
                                              comment: "The General achievement category")
    static let PillsTag = NSLocalizedString("Pills",
                                            comment: "The General achievement category")
    static let GamesTag = NSLocalizedString("Games",
                                            comment: "The General achievement category")
  }
}