import Foundation
import UIKit
import SwiftyJSON

/// Subclass of CollectionPostsEndpoint responsible for retrieving data from `EndpointType.Posts`
public class PostsEndpoint : CollectionPostsEndpoint {
    /// Required from `Endpoint` protocol
    override public var path: String { return EndpointType.Posts.path() }
    
    /// sub-class class object.
    override var subCollectionsPostsType: CollectionPosts.Type { return Posts.self }
}