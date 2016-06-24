import Foundation
import CoreData

/// Medicine containing name, interval and if is set as the current one (among other fields)
public class Medicine: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var isCurrent: Bool
    @NSManaged public var registries: NSSet
    @NSManaged public var internalInterval: Int64
    @NSManaged public var notificationTime: NSDate?
    @NSManaged public var remainingMedicine: Int64
    @NSManaged public var lastStockRefill: NSDate?
}
