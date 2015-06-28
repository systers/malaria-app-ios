import Foundation

extension NSSet {
    /// Converts the NSSet to a array
    
    /// :returns: `[T]`
    func convertToArray<T>() -> [T]{
        return allObjects.map {$0 as! T}
        
    }
}