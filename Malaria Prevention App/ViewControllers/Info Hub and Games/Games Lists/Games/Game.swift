import Foundation

/// A protocol for the models in the Game MVC.

protocol Game {
  
  static var name: String { get }
  var numberOfLevels: Int { get }
  var maximumScore: Int { get set }
  
  // Represents a short description of the rules for the game.
  static var rules: String { get }
}