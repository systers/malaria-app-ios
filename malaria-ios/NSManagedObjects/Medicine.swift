import Foundation
import CoreData

class Medicine: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var isCurrent: Bool
    @NSManaged var weekly: Bool
    @NSManaged var registries: NSMutableSet
    @NSManaged var notificationTime: NSDate?
}
