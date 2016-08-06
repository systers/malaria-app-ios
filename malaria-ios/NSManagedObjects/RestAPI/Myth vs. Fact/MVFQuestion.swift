import Foundation
import CoreData

/**
 A Rapid Fire Game entry containing:
 - `title`: The question's description.
 - `correctAnswer`: A bool representing if the statement was correct or not.
 */

class MVFStatement: NSManagedObject {
  
  @NSManaged var title: String
  @NSManaged var correctAnswer: Bool
  
  @NSManaged var contained_in: CollectionMVFStatements
}
