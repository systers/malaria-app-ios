import UIKit

class RapidFireGame: Game {
  
  var entries: [RapidFireGameEntry] = []
  
  init() {
    let entry1 = RapidFireGameEntry(question: "Question 1 (answer 2)", answers: ["Answer 1", "Answer 2", "Answer 3"], correctAnswer: 1)
    let entry2 = RapidFireGameEntry(question: "Question 2 (answer 1)", answers: ["Answer 1", "Answer 2", "Answer 3"], correctAnswer: 0)
    let entry3 = RapidFireGameEntry(question: "Question 3 (answer 3)", answers: ["Answer 1", "Answer 2", "Answer 3"], correctAnswer: 2)
    
    entries.appendContentsOf([entry1, entry2, entry3])
    
    super.init(numberOfLevels: entries.count, name: "Rapid Fire")
  }
}

class RapidFireGameEntry {
  
  let question: String, answers: [String], correctAnswer: Int
  
  init(question: String,
       answers: [String],
       correctAnswer: Int) {
    self.question = question
    self.answers = answers
    self.correctAnswer = correctAnswer
  }
}