import Foundation

extension Item{
    func add(number: Int){
        self.number += number
    }
    
    func remove(number: Int){
        self.number = max(self.number - number, 0)
    }
}