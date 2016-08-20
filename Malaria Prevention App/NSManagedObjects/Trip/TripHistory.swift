import CoreData

/// Trip history class containing only the location.

class TripHistory: NSManagedObject {

    @NSManaged var location: String
    @NSManaged var timestamp: NSDate
}
