import Foundation

class Game {
  
  var numberOfLevels: Int
  var name: String
  
  // Represents a short description of the rules for the game
  var rules: String
  
  init(numberOfLevels: Int, name: String, rules: String) {
    self.numberOfLevels = numberOfLevels
    self.name = name
    self.rules = rules
  }
}