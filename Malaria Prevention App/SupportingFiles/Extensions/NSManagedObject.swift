import Foundation
import UIKit

extension NSManagedObject {
  
  /// Converts MyTarget.ClassName to ClassName.
  
  private static func getSimpleClassName(c: AnyClass) -> String {
    return c.description().componentsSeparatedByString(".").last!
  }
  
  /**
   Delete object from context.
   
   - parameter context: The context.
   */
  
  func deleteFromContext(context: NSManagedObjectContext) {
    context.deleteObject(self)
  }
  
  /**
   Instantiates a new NSManagedObject.
   
   After creation, the deletion must be done explicitly.
   
   - parameter entity: The class of any subclass of NSManagedObject.
   - parameter context: The context.
   
   - returns: A new NSManagedObject of the type given by argument.
   */
  
  static func create<T : NSManagedObject>(entity: T.Type, context: NSManagedObjectContext) -> T {
    let name = getSimpleClassName(entity)
    return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context) as! T
  }
  
  /**
   Retrieves every object in the CoreData.
   
   - parameter entity: The class of any subclass of `NSManagedObject`.
   - parameter context: The context.
   
   - returns: An array of `NSManagedObject` of the type given by argument.
   */
  
  static func retrieve<T : NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil,
                       fetchLimit: Int = Int.max, context: NSManagedObjectContext) -> [T] {
    let name = getSimpleClassName(entity)
    
    let fetchRequest = NSFetchRequest(entityName: name)
    fetchRequest.predicate = predicate
    fetchRequest.fetchLimit = fetchLimit
    
    var value = [T]()
    
    do {
      value = try context.executeFetchRequest(fetchRequest) as! [T]
    } catch _ {
      value = []
    }
    
    return value
  }
  
  /**
   Deletes every object in the CoreData.
   
   - parameter entity: The class of any subclass of NSManagedObject.
   - parameter context: The context.
   */
  
  static func clear<T : NSManagedObject>(entity: T.Type, context : NSManagedObjectContext) {
    let elements = entity.retrieve(entity, context: context)
    elements.foreach({context.deleteObject($0)})
  }
}