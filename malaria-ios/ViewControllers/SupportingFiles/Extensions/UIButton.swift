import Foundation
import UIKit

extension UIButton {
  
  /// Widens hitArea of every UIButton to at least 44 pixels as suggested in Apple's Human Interface Guidelines.
  
  override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
    let buttonSize = frame.size
    
    let extraWidth = max(44 - buttonSize.width, 0)
    let extraHeight = max(44 - buttonSize.height, 0)
    
    let originX: CGFloat = 0 - (extraWidth/2)
    let originY: CGFloat = 0 - (extraHeight/2)
    let width: CGFloat = buttonSize.width + extraWidth
    let height: CGFloat = buttonSize.height + extraHeight
    let largerFrame = CGRect(x: originX, y: originY, width: width, height: height)
    
    return (CGRectContainsPoint(largerFrame, point)) ? self : nil
  }
}