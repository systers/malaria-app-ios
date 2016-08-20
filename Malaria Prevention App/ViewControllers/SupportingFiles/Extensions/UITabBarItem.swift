import Foundation
import UIKit

extension UITabBarItem {
  
  /// Image when selected. The other similar field in the storyboard doesn't work.
  
  @IBInspectable var imageWhenSelected: UIImage {
    get {
      return self.selectedImage!
    }
    set(image) {
      self.selectedImage = image
    }
  }
}