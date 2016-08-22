import SwiftyJSON

/// Endpoint protocol for retrieving and storing information from the remote JSON server.

protocol Endpoint {
  
  /// Full URL to the endpoint.
  
  var path: String { get }
  
  /**
   Parses the json and retrieves a NSManagedObject.
   
   Keep in mind that the object is created in the CoreData,
   therefore any deletion must be done explicitly.
   
   - parameter data: JSON data.
   - parameter context: The current context.
   
   - returns: The parsed object or `nil` if parse failed.
   */
  
  func retrieveJSONObject(data: JSON, context: NSManagedObjectContext) -> NSManagedObject?
  
  /**
   Clear all NSManagedObjects used by the endpoint.
   
   - parameter context: The current context.
   */
  
  func clearFromDatabase(context: NSManagedObjectContext)
}