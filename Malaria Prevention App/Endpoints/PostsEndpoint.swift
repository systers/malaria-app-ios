import UIKit
import SwiftyJSON

/// Subclass of CollectionPostsEndpoint responsible for retrieving data from `EndpointType.Posts`.

class PostsEndpoint : CollectionPostsEndpoint {
  
  /// Required from `Endpoint` protocol.
  
  override var path: String {
    return EndpointType.Posts.path()
  }
  
  /// Sub-class class object.
  
  override var subCollectionsPostsType: CollectionPosts.Type { return Posts.self }
}