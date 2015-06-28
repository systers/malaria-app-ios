import Foundation
import UIKit
import SwiftyJSON

class GoalsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Goals.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Goals.self } }
}