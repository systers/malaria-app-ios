import Foundation
import UIKit

@IBDesignable extension UIView {
  
  /// Sets corner radius. Specify half width to make a full circle.
  
  @IBInspectable  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  /// Border width.
  
  @IBInspectable  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    
    set(value) {
      layer.borderWidth = value
    }
  }
  
  /// Border color.
  
  @IBInspectable  var borderColor: UIColor? {
    get {
      return UIColor(CGColor: layer.borderColor!)
    }
    set(value) {
      layer.borderColor = value?.CGColor
    }
  }
  
  // Make views blink at a given rate.
  
  func blink(withRate rate: Double, completion: (Bool) -> Void) {
    self.alpha = 1.0;
    UIView.animateWithDuration(rate,
                               delay: 0.0,
                               options: [.CurveEaseInOut, .Autoreverse],
                               animations: { [weak self] in self?.alpha = 0.0 },
                               completion: completion)
  }
}