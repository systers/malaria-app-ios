import Foundation
import CoreData

/// Abstract class representing a collection of posts.

class CollectionPosts: NSManagedObject {

    @NSManaged var posts: NSSet
}
