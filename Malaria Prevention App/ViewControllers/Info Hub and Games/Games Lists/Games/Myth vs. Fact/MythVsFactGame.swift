import UIKit

/// The MythVsFact Game Model.

class MythVsFactGame {
  
  var entries: [MVFGameEntry] = []
  var _maximumScore: Int = 0
  
  init() {
    let entry1 = MVFGameEntry(statement: NSLocalizedString("Statement 1", comment: ""),
                              correctAnswer: false)
    let entry2 = MVFGameEntry(statement: NSLocalizedString("Statement 2", comment: ""),
                              correctAnswer: true)
    let entry3 = MVFGameEntry(statement: NSLocalizedString("Statement 3", comment: ""),
                              correctAnswer: false)
    let entry4 = MVFGameEntry(statement: NSLocalizedString("Statement 4", comment: ""),
                              correctAnswer: true)
    let entry5 = MVFGameEntry(statement: NSLocalizedString("Statement 5", comment: ""),
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
  
  static var name: String { return NSLocalizedString("Myth vs. Fact", comment: "The name of the MVF game") }
  static var rules: String { return NSLocalizedString("MythVsFact Rules", comment: "The rules of the Myth vs. Fact game") }
  
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