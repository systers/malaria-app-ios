import SwiftyJSON

/**
 Responsible for retrieving data for the game "Myth vs. Fact"
 from `EndpointType.MVFStatements`.
 */

class MVFStatementsEndpoint: CollectionMVFStatementsEndpoint {
  
  /// Required from `Endpoint` protocol.
  override var path: String {
    return EndpointType.MVFStatements.path()
  }
  
  /// sub-class class object.
  override var subCollectionsPostsType: CollectionMVFStatements.Type {
    return MVFStatements.self
  }
  
}