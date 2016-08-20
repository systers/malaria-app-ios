import Foundation
import UIKit
import SwiftyJSON

/// Collection for the Myth vs. Fact Endpoint.

class CollectionMVFStatementsEndpoint {
  
  var path: String { fatalError("Please specify path") }
  
  /// subCollectionClassType: Specify the subclass of CollectionPosts.
  var subCollectionsPostsType: CollectionMVFStatements.Type {
    fatalError("Please specify collection type")
  }
  
  private func getQuestions(data: [JSON], context: NSManagedObjectContext) -> [MVFStatement]? {
    let result: [MVFStatement] = []
    // TODO:
    return result
  }
}

extension CollectionMVFStatementsEndpoint: Endpoint {
  
  func retrieveJSONObject(data: JSON, context: NSManagedObjectContext) -> NSManagedObject? {
    // TODO:
    return nil
  }
  
  func clearFromDatabase(context: NSManagedObjectContext) {
    subCollectionsPostsType.clear(subCollectionsPostsType.self, context: context)
  }
}