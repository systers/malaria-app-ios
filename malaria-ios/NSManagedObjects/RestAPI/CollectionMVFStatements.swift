import Foundation
import CoreData

/**
 A collection of statements for the
 Myth vs. Fact game.
 */

public class CollectionMVFStatements: NSManagedObject {
  
  @NSManaged public var statements: NSSet
}
