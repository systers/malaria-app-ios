import CoreData

/**
 A collection of statements for the
 Myth vs. Fact game.
 */

class CollectionMVFStatements: NSManagedObject {
  
  @NSManaged var statements: NSSet
}
