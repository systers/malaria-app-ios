import Foundation
import UIKit

extension UIStoryboard {
  
  /// Converts MyTarget.ClassName to ClassName.
  
  private class func getSimpleClassName(c: AnyClass) -> String {
    return c.description().componentsSeparatedByString(".").last!
  }
  
  /**
   Instantiates a view controller from the storyboard main by default
   The storyboard Id must be equal to the name of the class. This is changed in the storyboard file.
   
   - parameter name: (optional) The name of the storyboard (default is Main).
   - parameter viewControllerClass: Class of the view controller.
   
   - returns: A new instance of the view controller.
   */
  
  static func instantiate <C:UIViewController> (viewControllerClass: C.Type, fromStoryboard name: String = "Main") -> C {
    let storyboard = UIStoryboard(name: name, bundle: nil)
    let storyboardId = UIStoryboard.getSimpleClassName(viewControllerClass)
    return storyboard.instantiateViewControllerWithIdentifier(storyboardId) as! C
  }
}