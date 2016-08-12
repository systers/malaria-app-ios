import Foundation
import CoreData

/// A post, containing mostly a title and a description among other fields.

class Post: NSManagedObject {
  
  @NSManaged var created_at: String
  @NSManaged var id: Int64
  @NSManaged  var owner: Int64
  @NSManaged  var post_description: String
  @NSManaged var title: String
  @NSManaged  var updated_at: String
  @NSManaged  var contained_in: CollectionPosts
  
}
