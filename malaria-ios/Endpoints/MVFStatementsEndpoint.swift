import UIKit
import SwiftyJSON

/// Responsible for retrieving data for the game "Myth vs. Fact"
/// from `EndpointType.MVFStatements`

public class MVFStatementsEndpoint: CollectionMVFStatementsEndpoint {
  /// Required from `Endpoint` protocol
  override public var path: String {
    return EndpointType.MVFStatements.path()
  }
  
  /// sub-class class object.
  override var subCollectionsPostsType: CollectionMVFStatements.Type {
    return MVFStatements.self
  }
  
}