import Foundation
import CoreData

public class Registry: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var tookMedicine: Bool
}
