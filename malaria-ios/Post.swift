import Foundation
import CoreData

class Post: NSManagedObject {

    @NSManaged var created_at: String
    @NSManaged var id: Int
    @NSManaged var post_description: String
    @NSManaged var title: String
    @NSManaged var updated_at: String
    @NSManaged var owner: Int
    @NSManaged var contained_in: CollectionPosts
}
