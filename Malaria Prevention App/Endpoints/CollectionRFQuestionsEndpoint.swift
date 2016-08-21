import Foundation
import UIKit
import SwiftyJSON

class CollectionRFQuestionsEndpoint {
  
  var path: String { fatalError("Please specify path.") }
  
  /// subCollectionClassType: Specify the subclass of CollectionPosts.
  var subCollectionsPostsType: CollectionRFQuestions.Type {
    fatalError("Please specify collection type.")
  }
  
  private func getQuestions(data: [JSON], context: NSManagedObjectContext) -> [RFQuestion]? {
    let result: [RFQuestion] = []
    // TODO:
    return result
  }
}

extension CollectionRFQuestionsEndpoint: Endpoint {
  
  func retrieveJSONObject(data: JSON, context: NSManagedObjectContext) -> NSManagedObject? {
    // TODO:
    return nil
  }
  
  func clearFromDatabase(context: NSManagedObjectContext) {
    subCollectionsPostsType.clear(subCollectionsPostsType.self, context: context)
  }
}