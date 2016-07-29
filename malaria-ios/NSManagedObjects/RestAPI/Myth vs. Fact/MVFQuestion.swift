import Foundation
import CoreData

/**
 A Rapid Fire Game entry containing:
 - `title`: The question's description.
 - `correctAnswer`: A bool representing if the statement was correct or not.
 */

public class MVFStatement: NSManagedObject {
  
  @NSManaged public var title: String
  @NSManaged public var correctAnswer: Bool
  
  @NSManaged public var contained_in: CollectionMVFStatements
}
