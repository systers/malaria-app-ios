import Foundation

extension NSSet {
  
  /**
   Converts the NSSet to a array.
   
   - returns: The new array.
   */
  
  func convertToArray<T>() -> [T] {
    return allObjects.map {$0 as! T}
    
  }
}