import Foundation
import UIKit
import SwiftyJSON

class CohortsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Cohort.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Cohorts.self } }
}