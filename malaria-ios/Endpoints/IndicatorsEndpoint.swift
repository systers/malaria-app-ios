import Foundation
import UIKit
import SwiftyJSON

class IndicatorsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return EndpointType.Indicators.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Indicators.self } }
}