import Foundation
import CoreData

/// Abstract class representing a collection of posts
public class CollectionPosts: NSManagedObject {

    @NSManaged public var posts: NSSet
}
