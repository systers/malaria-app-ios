import Foundation
import CoreData

/// Trip Item
class Item: NSManagedObject {

    @NSManaged var check: Bool
    @NSManaged var name: String
    @NSManaged var quantity: Int64
    @NSManaged var associated_with: Trip
}
