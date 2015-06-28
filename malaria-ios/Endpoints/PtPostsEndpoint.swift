import Foundation
import UIKit
import SwiftyJSON

class PtPostsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Ptposts.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return PtPosts.self } }
}