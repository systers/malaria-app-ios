import UIKit

class RapidFireGame: Game {
  
  var entries: [RapidFireGameEntry] = []
  
  var achievementManager: RapidFireAchievementManager?

  // MARK: Game protocol
  var maximumScore: Int?
  
  var numberOfLevels: Int { return entries.count }
  var name: String { return "Rapid Fire" }
  var rules: String { return "- Answer questions quickly, under time pressure.\n\n"
    + "- Score Achievement Points for every correct answer you give." }
  
  init() {
    let entry1 = RapidFireGameEntry(question: "Question 1 (answer 2)",
                                    answers: ["Answer 1", "Answer 2", "Answer 3"],
                                    correctAnswer: 1)
    let entry2 = RapidFireGameEntry(question: "Question 2 (answer 1)",
                                    answers: ["Answer 1", "Answer 2", "Answer 3"],
                                    correctAnswer: 0)
    let entry3 = RapidFireGameEntry(question: "Question 3 (answer 3)",
                                    answers: ["Answer 1", "Answer 2", "Answer 3"],
                                    correctAnswer: 2)

    entries.appendContentsOf([entry1, entry2, entry3])
  }
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