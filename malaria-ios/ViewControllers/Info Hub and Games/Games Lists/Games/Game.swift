import Foundation

protocol Game {
  
  var numberOfLevels: Int { get }
  var name: String { get }
  var maximumScore: Int? { get set }
  
  // Represents a short description of the rules for the game
  var rules: String { get }  
}