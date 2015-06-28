import Foundation
import UIKit
import SwiftyJSON

class RegionsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Regions.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Regions.self } }
}