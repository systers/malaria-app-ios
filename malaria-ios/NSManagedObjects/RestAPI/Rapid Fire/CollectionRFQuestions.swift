import Foundation
import CoreData

/**
 A collection of questions for the
 Rapid Fire game.
 */

class CollectionRFQuestions: NSManagedObject {
  
  @NSManaged var questions: NSSet
}
