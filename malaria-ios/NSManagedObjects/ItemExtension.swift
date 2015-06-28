import Foundation

extension Item{
    func add(number: Int64){
        self.number += number
    }
    
    func remove(number: Int64){
        self.number = max(self.number - number, 0)
    }
}