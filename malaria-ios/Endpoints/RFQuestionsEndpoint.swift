import UIKit
import SwiftyJSON

/// Responsible for retrieving data from `EndpointType.RFQuestions`

public class RFQuestionsEndpoint: CollectionRFQuestionsEndpoint {
  /// Required from `Endpoint` protocol
  override public var path: String {
    return EndpointType.RapidFireQuestions.path()
  }
  
  /// sub-class class object.
  override var subCollectionsPostsType: CollectionRFQuestions.Type {
    return RFQuestions.self
  }
  
}