import UIKit

class MythVsFactGame {
  
  var entries: [MVFGameEntry] = []

  init() {
    let entry1 = MVFGameEntry(statement: "Statement 1 (true)",
                              correctAnswer: true)
    let entry2 = MVFGameEntry(statement: "Statement 2 (false)",
                              correctAnswer: false)
    let entry3 = MVFGameEntry(statement: "Statement 3 (false)",
                              correctAnswer: false)
    
    entries.appendContentsOf([entry1, entry2, entry3])
  }
}

extension MythVsFactGame: Game {
  
  var numberOfLevels: Int { return entries.count }
  var name: String { return "Myth vs. Fact" }
  var rules: String { return "- Decide whether the statement is correct or false by dragging in its corresponding container.\n\n"
    + "- Score Achievement Points for every correct answer you give." }
  
  func defineAchievements() { }
  
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