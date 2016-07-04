import Foundation
import UIKit

extension UIStoryboard {
    ///Converts MyTarget.ClassName to ClassName
    private class func getSimpleClassName(c: AnyClass) -> String {
        return c.description().componentsSeparatedByString(".").last!
    }
    
    /// Instantiate a view controller from the storyboard main by default
    /// The storyboard Id must be equal to the name of the class. This is changed in the storyboard file.
    ///
    /// - parameter `String: optional`: named (default is Main)
    /// - parameter `C`:: Class of the view controller
    ///
    /// - returns: `C`: A new instance of the view controller
    public static func instantiate <C:UIViewController> (viewControllerClass: C.Type, fromStoryboard name: String = "Main") -> C {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let storyboardId = UIStoryboard.getSimpleClassName(viewControllerClass)
        return storyboard.instantiateViewControllerWithIdentifier(storyboardId) as! C
    }
}