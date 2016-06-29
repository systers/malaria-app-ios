import Foundation

class Game: NSObject {
  
  var numberOfLevels: Int
  var name: String
  
  init(numberOfLevels: Int, name: String) {
    self.numberOfLevels = numberOfLevels
    self.name = name
    super.init()
  }
}