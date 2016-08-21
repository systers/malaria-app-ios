import Alamofire
import SwiftyJSON

/// Responsible for syncing remote server with CoreData.

class SyncManager : CoreDataContextManager {
  
  private let user = "TestUser"
  private let password = "password"
  
  /// Init.
  override init(context: NSManagedObjectContext!) {
    super.init(context: context)
  }
  
  /// Dictionary with key full endpoint url path and object an instance of `Endpoint`.
  var endpoints: [String : Endpoint] = [
    EndpointType.Posts.path() : PostsEndpoint(),
    ]
  
  /**
   Syncs a specific endpoint.
   
   - parameter path: The full path.
   - parameter save: Save context after success.
   - parameter completionHandler: A block that will be executed on completion (default nil).
   */
  
  func sync(path: String,
            save: Bool = false,
            completionHandler: ((url: String, error: NSError?)->())? = nil) {
    
    let expandedCompletionHandler = { (url: String, error: NSError?) in
      completionHandler?(url: url, error: error)
      
      if (error != nil) {
        Logger.Error(error!.localizedDescription)
      } else if (error == nil && save) {
        Logger.Info("Saving to coreData")
        CoreDataHelper.sharedInstance.saveContext(self.context)
      }
    }
    
    if let endpoint = endpoints[path] {
      remoteFetch(endpoint, completion: expandedCompletionHandler)
    } else {
      Logger.Error("Bad path provided to sync")
      completionHandler?(url: path, error: NSError(domain: "UNREACHABLE", code: 9999, userInfo: [:]))
    }
  }
  
  /**
   Syncs every endpoint.
   
   Runs the specified completion handler after syncing every endpoint.
   
   - parameter completionHandler: A block that could be executed on completion (default nil).
   */
  
  func syncAll(completionHandler: (()->())? = nil ) {
    
    var count = endpoints.count
    func completionHandlerExpanded(url: String, error: NSError?) {
      count -= 1
      if(count == 0) {
        Logger.Info("Sync complete")
        completionHandler?()
      }
      
      Logger.Info("Saving to core data")
      CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    for (path, _) in endpoints{
      sync(path, completionHandler: completionHandlerExpanded)
    }
  }
  
  private func headers() -> [String : String] {
    
    // Set up the base64-encoded credentials.
    let loginString = NSString(format: "%@:%@", user, password)
    let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
    let base64LoginString = loginData.base64EncodedStringWithOptions([])
    
    return ["Authorization":"Basic \(base64LoginString)"]
  }
  
  private func remoteFetch(endpoint: Endpoint,
                           save: Bool = false,
                           completion: ((url: String, error: NSError?)->())? = nil) {
    Logger.Info("Syncing: \(endpoint.path)")
    
    Alamofire.request(.GET, endpoint.path, headers: headers(), parameters: ["format": "json"]).validate().responseJSON { response in
      var resultError: NSError? = nil
      
      switch response.result {
      case .Success:
        
        if let data = response.result.value {
          let json = JSON(data)
          endpoint.clearFromDatabase(self.context)
          
          if endpoint.retrieveJSONObject(json, context: self.context) != nil {
            Logger.Info("Success \(endpoint.path)")
          }else{
            Logger.Error("Error parsing \(endpoint.path)")
            resultError = NSError(domain: "PARSE_ERROR", code: 9999, userInfo: [:])
          }
        }
        
      case .Failure(_):
        resultError = NSError(domain: "CONNECTION_ERROR", code: 9999, userInfo: [:])
      }
      
      completion?(url: endpoint.path, error: resultError)
    }
  }
}