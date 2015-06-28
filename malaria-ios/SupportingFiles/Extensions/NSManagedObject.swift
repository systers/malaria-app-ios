import Foundation
import UIKit

extension NSManagedObject{

    ///Converts MyTarget.ClassName to ClassName
    class func getSimpleClassName(c: AnyClass) -> String {
        return c.description().componentsSeparatedByString(".").last!
    }
    
    /// delete object from contect
    ///
    /// :param: `NSManagedObjectContext`: by default is the one defined in CoreDataHelper
    public func deleteFromContext(context: NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!){
        context.deleteObject(self)
    }
    
    /// Instanciates a new NSManagedObject.
    ///
    /// After creation, his deletion must be done explicitly
    ///
    /// :param: `T.Type`: The class of any subclass of NSManagedObject
    /// :param: `NSManagedObjectContext`: by default is the one defined in CoreDataHelper
    /// :returns: `T`: A new NSManagedObject of the type given by argument
    class func create<T : NSManagedObject>(entity: T.Type, context: NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!) -> T{
        let name = getSimpleClassName(entity)
        
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context) as! T
    }
    
    /// Retrieves every object in the CoreData.
    ///
    /// :param: `T.Type`: The class of any subclass of NSManagedObject
    /// :param: `NSManagedObjectContext`: by default is the one defined in CoreDataHelper
    /// :returns: `[T]`: A array of NSManagedObject of the type given by argument
    class func retrieve<T : NSManagedObject>(entity: T.Type, context : NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!) -> [T]{
        let name = getSimpleClassName(entity)
        
        let fetchRequest = NSFetchRequest(entityName: name)
        return context.executeFetchRequest(fetchRequest, error: nil) as! [T]
    }
    
    /// Deletes every object in the CoreData.
    ///
    /// :param: `T.Type`: The class of any subclass of NSManagedObject
    /// :param: `NSManagedObjectContext`: by default is the one defined in CoreDataHelper
    class func clear<T : NSManagedObject>(entity: T.Type, context : NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!){
        let elements = entity.retrieve(entity, context: context)
        elements.map({context.deleteObject($0)})
    }
}