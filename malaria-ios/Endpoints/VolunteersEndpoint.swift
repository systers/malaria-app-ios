import Foundation
import UIKit
import SwiftyJSON

class VolunteersEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Volunteer.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Volunteers.self } }
}