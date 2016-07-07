import Foundation
import UIKit
import SwiftyJSON

// Collection for the Myth vs. Fact Endpoint
public class CollectionMVFStatementsEndpoint : Endpoint {
  public var path: String { fatalError("Please specify path") }
  
  /// subCollectionClassType: Specify the subclass of CollectionPosts
  var subCollectionsPostsType: CollectionMVFStatements.Type {
    fatalError("Please specify collection type")
  }
  
  public func retrieveJSONObject(data: JSON, context: NSManagedObjectContext) -> NSManagedObject? {
    // TODO
    return nil
  }
  
  private func getQuestions(data: [JSON], context: NSManagedObjectContext) -> [MVFStatement]? {
    let result: [MVFStatement] = []
    // TODO
    return result
  }
  
  /// Required from `Endpoint` protocol
  public func clearFromDatabase(context: NSManagedObjectContext) {
    subCollectionsPostsType.clear(subCollectionsPostsType.self, context: context)
  }
  
}