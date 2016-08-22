import UIKit
import Toast_Swift

class ToastHelper {
  typealias ToastCompletion = ((didTap: Bool) -> Void)
  
  /**
   Presents a toast with the specified optional parameters.
   
   - parameter message: The message of the toast.
   - parameter duration: The time duration of the toast.
   - parameter title: The title of the toast.
   - parameter image: An icon for the toast.
   - parameter style: Defined a ToastStyle. Default, text alignment on the middle.
   - parameter completion: Callback block when toast finishes.
   - parameter viewController: The View Controller that will present the Toast.
   (application's `RootViewController` by default)
   */
  
  static func makeToast(message: String?,
                        duration: NSTimeInterval = 3,
                        position: ToastPosition = .Bottom,
                        title: String? = nil,
                        image: UIImage? = nil,
                        style: ToastStyle? = nil,
                        viewController: UIViewController? = nil,
                        completion: ToastCompletion? = nil) {
    
    var vc = viewController
    var defaultStyle = style
    
    if vc == nil {
      vc = UIApplication.sharedApplication().keyWindow?.rootViewController
    }
    
    // Reach the top of the views stack.
    while vc?.presentedViewController != nil {
        vc = vc?.presentedViewController
    }
    
    if defaultStyle == nil {
      defaultStyle = ToastStyle()
      defaultStyle!.messageAlignment = .Center
    }
    
    vc!.view.makeToast(message,
                       duration: duration,
                       position: position,
                       title: title,
                       image: image,
                       style: defaultStyle   ,
                       completion: completion)
  }
}