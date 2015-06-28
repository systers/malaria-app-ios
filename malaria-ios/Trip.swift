import Foundation
import CoreData

class Trip: NSManagedObject {

    @NSManaged var medicine: String
    @NSManaged var cashToBring: Int
    @NSManaged var reminderDate: NSDate
    @NSManaged var location: String
    @NSManaged var items: NSMutableSet

}