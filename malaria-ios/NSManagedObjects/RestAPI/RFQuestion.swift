import Foundation
import CoreData

/**
 A Rapid Fire Game entry containing:
 - `title`: The question's description.
 - `answers`: An array of possible answer to it.
 - `correctAnswer`: The correct answer's index in the `answers` array.
 */

public class RFQuestion: NSManagedObject {
  
  @NSManaged public var answers: [String]
  @NSManaged public var title: String
  @NSManaged public var correctAnswer: Int
  
  @NSManaged public var created_at: String
  @NSManaged public var id: Int64
  @NSManaged public var owner: Int64
  @NSManaged public var updated_at: String
  @NSManaged public var contained_in: CollectionRFQuestions
  
}
