import Foundation
import Social

/// Protocol for view controllers who can share to social media.
protocol SocialMediaController {
    func share(socialItem: SocialShareable, toMedia: SocialMediaType)
}

// Example of a Social Media Controller
extension DailyStatsTableViewController: SocialMediaController {
    func share(socialItem: SocialShareable, toMedia: SocialMediaType) {
        
        Logger.Info("User wants to share to \(toMedia.rawValue)")
        
        if SLComposeViewController.isAvailableForServiceType(toMedia.rawValue) {
            let controller = SLComposeViewController(forServiceType: toMedia.rawValue)
            controller.setInitialText(socialItem.message)
            controller.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                switch result {
                case SLComposeViewControllerResult.Cancelled:
                    Logger.Info("User cancelled sharing to \(toMedia.rawValue)")
                case SLComposeViewControllerResult.Done:
                    Logger.Info("User has shared to \(toMedia.rawValue)")
                }
            }
            
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            Logger.Error("\(toMedia.rawValue) is not avaliable")
        }
        
    }
}
