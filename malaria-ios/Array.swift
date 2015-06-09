import Foundation

extension Array{
    func removeObject<U: Equatable>(object: U, fromArray:[U]) -> [U]{
        return fromArray.filter { return $0 != object }
    }
    
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
