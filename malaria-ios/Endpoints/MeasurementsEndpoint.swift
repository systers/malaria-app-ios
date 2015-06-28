import Foundation
import UIKit
import SwiftyJSON

class MeasurementsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Measurement.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Measurements.self } }
}