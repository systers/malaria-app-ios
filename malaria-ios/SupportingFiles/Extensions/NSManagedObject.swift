import Foundation
import UIKit

public extension NSManagedObject {

  /// Converts MyTarget.ClassName to ClassName
  private static func getSimpleClassName(c: AnyClass) -> String {
    return c.description().componentsSeparatedByString(".").last!
  }

  /// Delete object from contect
  ///
  /// - parameter `NSManagedObjectContext`:
  public func deleteFromContext(context: NSManagedObjectContext){
    context.deleteObject(self)
  }

  /// Instanciates a new NSManagedObject.
  ///
  /// After creation, the deletion must be done explicitly
  ///
  /// - parameter `T.Type`:: The class of any subclass of NSManagedObject
  /// - parameter `NSManagedObjectContext`:
  ///
  /// - returns: `T`: A new NSManagedObject of the type given by argument
  public static func create<T : NSManagedObject>(entity: T.Type, context: NSManagedObjectContext) -> T{
    let name = getSimpleClassName(entity)
    return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context) as! T
  }

  /// Retrieves every object in the CoreData.
  ///
  /// - parameter `T.Type`:: The class of any subclass of NSManagedObject
  /// - parameter `NSManagedObjectContext`:
  ///
  /// - returns: `[T]`: A array of NSManagedObject of the type given by argument
  public static func retrieve<T : NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil,
    fetchLimit: Int = Int.max, context : NSManagedObjectContext) -> [T]{
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

  /// Deletes every object in the CoreData.
  ///
  /// - parameter `T.Type`:: The class of any subclass of NSManagedObject
  /// - parameter `NSManagedObjectContext`:
  public static func clear<T : NSManagedObject>(entity: T.Type, context : NSManagedObjectContext){
    let elements = entity.retrieve(entity, context: context)
    elements.foreach({context.deleteObject($0)})
  }
}