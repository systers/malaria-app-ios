import Foundation
import CoreData

/**
 A Rapid Fire Game entry containing:
 - `title`: The question's description.
 - `answers`: An array of possible answer to it.
 - `correctAnswer`: The correct answer's index in the `answers` array.
 */

class RFQuestion: NSManagedObject {
  
  @NSManaged var answers: [String]
  @NSManaged var title: String
  @NSManaged var correctAnswer: Int
  
  @NSManaged var contained_in: CollectionRFQuestions
}
