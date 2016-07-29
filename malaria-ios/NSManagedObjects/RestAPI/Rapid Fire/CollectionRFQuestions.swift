import Foundation
import CoreData

/**
 A collection of questions for the
 Rapid Fire game.
 */

public class CollectionRFQuestions: NSManagedObject {
  
  @NSManaged public var questions: NSSet
}
