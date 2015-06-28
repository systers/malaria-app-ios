import Foundation
import UIKit
import SwiftyJSON

class OutputsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Outputs.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Outputs.self } }
}