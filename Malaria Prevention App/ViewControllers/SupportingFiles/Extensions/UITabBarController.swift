import Foundation
import UIKit

@IBDesignable extension UITabBarController {
  
  /**
   Set to false if you want to disable the bottom bar:
   
   Sets `barTintColor` to clearColor.
   Sets `backgroundImage` and `shadowImage` to UIImage.
   */
  
  @IBInspectable var showBar: Bool {
    get {
      fatalError("Never meant to be called.")
    }
    
    set {
      if(!newValue) {
        UITabBar.appearance().barTintColor = UIColor.clearColor()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
      }
    }
  }
}