import Foundation
import UIKit

/**
 Runs the function given by argument in main_queue after the specified seconds.
 
 - parameter seconds: The time in seconds.
 */

func delay(seconds: Double, function: () -> ()) {
  let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
  dispatch_after(time, dispatch_get_main_queue(), function)
}

/**
 Opens the URL.
 
 - parameter url: The URL.
 
 - returns: True if opened successfully, false if not.
 */

func openUrl(url: NSURL!) -> Bool {
  if !UIApplication.sharedApplication().canOpenURL(url) {
    Logger.Error("Can't open Url \(url)")
    return false
  }

  UIApplication.sharedApplication().openURL(url)
  return true
}