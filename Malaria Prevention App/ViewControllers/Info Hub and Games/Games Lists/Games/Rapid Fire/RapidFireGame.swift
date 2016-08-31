import UIKit

// The Rapid Fire game model.

class RapidFireGame {
  
  var entries: [RapidFireGameEntry] = []
  var _maximumScore: Int = 0
  
  init() {
    
    
    let firstQuestionTitle = NSLocalizedString("Question 1", comment: "")
    let firstQuestionsAnswers = [NSLocalizedString("Daily", comment: ""),
                                 NSLocalizedString("Weekly", comment: ""),
                                 NSLocalizedString("Monthly", comment: "")]
    
    let entry1 = RapidFireGameEntry(question: firstQuestionTitle,
                                    answers: firstQuestionsAnswers,
                                    correctAnswer: 1)
    
    let secondQuestionTitle = NSLocalizedString("Question 2", comment: "")
    let secondQuestionsAnswers = [NSLocalizedString("Virus", comment: ""),
                                  NSLocalizedString("Bacteria", comment: ""),
                                  NSLocalizedString("Protozoa", comment: "")]
    
    let entry2 = RapidFireGameEntry(question: secondQuestionTitle,
                                    answers: secondQuestionsAnswers,
                                    correctAnswer: 2)
    
    let thirdQuestionTitle = NSLocalizedString("Question 3", comment: "")
    let thirdQuestionsAnswers = firstQuestionsAnswers
    
    let entry3 = RapidFireGameEntry(question: thirdQuestionTitle,
                                    answers: thirdQuestionsAnswers,
                                    correctAnswer: 0)
    
    let fourthQuestionTitle = NSLocalizedString("Question 4", comment: "")
    let fourthQuestionsAnswers = [NSLocalizedString("Female Aedes", comment: ""),
                                  NSLocalizedString("Female Anopheles", comment: ""),
                                  NSLocalizedString("Male Aedes", comment: "")]
    
    let entry4 = RapidFireGameEntry(question: fourthQuestionTitle,
                                    answers: fourthQuestionsAnswers,
                                    correctAnswer: 1)
    
    let fifthQuestionTitle = NSLocalizedString("Question 5", comment: "")
    let fifthQuestionsAnswers = firstQuestionsAnswers
    
    let entry5 = RapidFireGameEntry(question: fifthQuestionTitle,
                                    answers: fifthQuestionsAnswers,
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
  
  static var name: String {
    return NSLocalizedString("Rapid Fire", comment: "Game name.")
  }
  
  static var rules: String {
    return NSLocalizedString("Rapid Fire game rules", comment: "The Rapid Fire game rules.")
  }
  
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