import Foundation
import UIKit
import SwiftyJSON

class OutcomesEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Outcomes.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Outcomes.self } }
}