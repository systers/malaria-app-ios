import Foundation
import CoreData

/// Registry containing the date and boolean indicating if the user took the medicine on that day.

class Registry: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var tookMedicine: Bool
}