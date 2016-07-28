import Foundation

extension Item {
  
  /** Increase number of items. Never greater than `Int64.max`
   
   - parameter `Int64`:: quantity
   */
  func add(number: Int64) {
    self.quantity = (self.quantity + number) % Int64.max
  }
  
  /** Decrease number of items
   
   - parameter `Int64`:: quantity always equal or greated than 0
   */
  func remove(number: Int64) {
    self.quantity = max(self.quantity - number, 0)
  }
  
  /// toggle check item
  func toogle() {
    self.check = !self.check
  }
}