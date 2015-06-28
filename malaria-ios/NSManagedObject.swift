import Foundation
import UIKit

extension NSManagedObject{
    public func deleteFromContext(context: NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!){
        context.deleteObject(self)
    }
    
    class func create<T : NSManagedObject>(entity: T.Type, context: NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!) -> T{
        let name = getSimpleClassName(entity)
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context) as! T
    }
    
    class func getSimpleClassName(c: AnyClass) -> String {
        return c.description().componentsSeparatedByString(".").last!
    }
}