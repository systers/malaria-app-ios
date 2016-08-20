import UIKit

/// The MythVsFact Game Model.

class MythVsFactGame {
  
  var entries: [MVFGameEntry] = []
  var _maximumScore: Int = 0
  
  init() {
    let entry1 = MVFGameEntry(statement: "Once you get malaria you will be immune from it for the rest of your life.",
                              correctAnswer: false)
    let entry2 = MVFGameEntry(statement: "Malaria is a life-threatening disease.",
                              correctAnswer: true)
    let entry3 = MVFGameEntry(statement: "You don’t have to worry about malaria in the dry season.",
                              correctAnswer: false)
    let entry4 = MVFGameEntry(statement: "Nearly half of the world's population is at risk of malaria.",
                              correctAnswer: true)
    let entry5 = MVFGameEntry(statement: "There is a vaccine for malaria.",
                              correctAnswer: false)
    
    entries.appendContentsOf([entry1, entry2, entry3, entry4, entry5])
  }
}

// MARK: Game protocol.

extension MythVsFactGame: Game {
  
  var maximumScore: Int {
    get {
      return _maximumScore
    }
    set {
      _maximumScore = newValue
    }
  }
  
  static var name: String { return "Myth vs. Fact" }
  static var rules: String { return "- Decide whether the statement is correct"
    + "or false by dragging in its corresponding container.\n\n"
    + "- Score Achievement Points for every correct answer you give.\n\n"
    + "- The correct answer will blink after each statement."
  }
  
  var numberOfLevels: Int { return entries.count }
}

class MVFGameEntry {
  
  /// The statement which needs to be questioned.
  let statement: String
  
  // Indicating the the index in the `answer` array of the correct answer.
  let correctAnswer: Bool
  
  init(statement: String, correctAnswer: Bool) {
    self.statement = statement
    self.correctAnswer = correctAnswer
  }
}