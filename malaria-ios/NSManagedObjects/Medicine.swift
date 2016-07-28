import Foundation
import CoreData

/**
 Medicine containing name, interval
 and if is set as the current one (among other fields)
 */

class Medicine: NSManagedObject {
  
  @NSManaged var name: String
  @NSManaged var isCurrent: Bool
  @NSManaged var registries: NSSet
  @NSManaged var internalInterval: Int64
  @NSManaged var notificationTime: NSDate?
  @NSManaged var remainingMedicine: Int64
  @NSManaged var lastStockRefill: NSDate?
}
