//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Achievement {

    @NSManaged var desc: String?
    @NSManaged var isUnlocked: NSNumber?
    @NSManaged var name: String?
    @NSManaged var tag: String?

}
