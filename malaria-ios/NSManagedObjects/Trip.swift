import Foundation
import CoreData

class Trip: NSManagedObject {
  
  @NSManaged  var medicine: String
  @NSManaged  var departure: NSDate
  @NSManaged  var arrival: NSDate
  @NSManaged  var location: String
  @NSManaged  var items: NSSet
  @NSManaged  var reminderTime: NSDate
  
}