import Foundation

/// Trip item.

class Item: NSManagedObject {
  
  /**
   Increase number of items. Never greater than `Int64.max`
   
   - parameter number: The quantity.
   */
  
  func add(number: Int64) {
    self.quantity = (self.quantity + number) % Int64.max
  }
  
  /**
   Decrease number of items.
   
   - parameter number: The quantity always equal or greated than 0.
   */
  
  func remove(number: Int64) {
    self.quantity = max(self.quantity - number, 0)
  }
  
  /// Toggle check item.
  
  func toogle() {
    self.check = !self.check
  }
}