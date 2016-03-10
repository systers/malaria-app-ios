//
//  SocialMediaController.swift
//  malaria-ios
//
//  Created by Eric Huang on 1/10/16.
//  Copyright © 2016 Bruno Henriques. All rights reserved.
//

import Foundation
import Social

/// Protocol for view controllers who can share to social media.
protocol SocialMediaController {
    func share(socialItem: SocialShareable, toMedia: SocialMediaType, withMessage: String)
}

// Example of a Social Media Controller
extension DailyStatsTableViewController: SocialMediaController {
    func share(socialItem: SocialShareable, toMedia: SocialMediaType, withMessage: String) {
        
        Logger.Info("User wants to share to \(toMedia.rawValue)")
        
        if SLComposeViewController.isAvailableForServiceType(toMedia.rawValue) {
            let controller = SLComposeViewController(forServiceType: toMedia.rawValue)
            controller.setInitialText(withMessage)
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
