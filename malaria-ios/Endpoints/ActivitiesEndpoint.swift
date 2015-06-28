import Foundation
import UIKit
import SwiftyJSON

class ActivitiesEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Activity.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Activities.self } }
}