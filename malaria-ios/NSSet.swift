import Foundation

extension NSSet {
    func convertToArray<T>() -> [T]{
        return allObjects.map {$0 as! T}
    }
}