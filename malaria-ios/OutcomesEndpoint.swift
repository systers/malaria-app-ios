import Foundation
import UIKit
import SwiftyJSON

class OutcomesEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Outcomes.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Outcomes.self } }
}