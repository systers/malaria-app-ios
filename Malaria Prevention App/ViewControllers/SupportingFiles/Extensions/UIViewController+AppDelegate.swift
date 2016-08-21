import UIKit

extension UIViewController {
  
  var appDelegate: AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
  }
}
