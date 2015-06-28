import Foundation
import UIKit
import SwiftyJSON

class RevPostsEndpoint : CollectionRevPostsEndpoint{
    override var path: String { get { return EndpointType.Revposts.path() } }
    override var subCollectionsRevPostsType: CollectionRevPosts.Type { get { return RevPosts.self } }
}