import UIKit

/// A label that presents padding.

class InsetLabel: UILabel {
  
  @IBInspectable let padding: CGFloat = 5
  
  override func drawTextInRect(rect: CGRect) {
    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(
      top: padding,
      left: padding,
      bottom: padding,
      right: padding)))
  }
}