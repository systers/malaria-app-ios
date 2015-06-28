import Foundation
import UIKit
import SwiftyJSON

class PostsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Posts.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Posts.self } }
}