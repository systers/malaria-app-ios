import Foundation
import UIKit
import SwiftyJSON

class ProjectsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Projects.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Projects.self } }
}