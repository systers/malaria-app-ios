import UIKit

// The Rapid Fire game model.

class RapidFireGame {
  
  var entries: [RapidFireGameEntry] = []
  var _maximumScore: Int = 0

  init() {
    let entry1 = RapidFireGameEntry(question: "Melfoquine should be taken:",
                                    answers: ["Daily", "Weekly", "Monthly"],
                                    correctAnswer: 1)
    let entry2 = RapidFireGameEntry(question: "Malaria is caused by:",
                                    answers: ["Virus", "Bacteria", "Protozoa"],
                                    correctAnswer: 2)
    let entry3 = RapidFireGameEntry(question: "Doxycycline should be taken: ",
                                    answers: ["Daily", "Weekly", "Monthly"],
                                    correctAnswer: 0)
    let entry4 = RapidFireGameEntry(question: "Malaria is transmitted through ... mosquito.",
                                    answers: ["Female Aedes", "Female Anopheles", "Male Aedes"],
                                    correctAnswer: 1)
    let entry5 = RapidFireGameEntry(question: "Malarone should be taken:",
                                    answers: ["Daily", "Weekly", "Monthly"],
                                    correctAnswer: 0)
    
    entries.appendContentsOf([entry1, entry2, entry3, entry4, entry5])
  }
}

// MARK: Game protocol.

extension RapidFireGame: Game {
  
  var maximumScore: Int {
    get {
      return _maximumScore
    }
    set {
      _maximumScore = newValue
    }
  }
  
  static var name: String { return "Rapid Fire" }
  static var rules: String { return "- Answer questions quickly, under time pressure.\n\n"
    + "- Score Achievement Points for every correct answer you give." }
  
  var numberOfLevels: Int { return entries.count }

}

class RapidFireGameEntry {
  
  /// The questions which needs to be answered.
  let question: String
  
  // An array with possible answer choices.
  let answers: [String]
  
  // Indicating the the index in the `answer` array of the correct answer.
  let correctAnswer: Int
  
  init(question: String, answers: [String], correctAnswer: Int) {
    self.question = question
    self.answers = answers
    self.correctAnswer = correctAnswer
  }
}