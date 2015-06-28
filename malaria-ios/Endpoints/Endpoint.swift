import SwiftyJSON

class Endpoint{
    /// default parameters for every request.
    ///
    /// :returns: `[String : String]`
    var parameters: [String: String]    { get { return ["format": "json"]}}
    
    /// full url to the endpoint
    ///
    /// :returns: `String`
    var path: String                    { get { fatalError("getEndpoint not implemented")} }
    
    /// Parses the json and retrieves a NSManagedObject
    ///
    /// Keep in mind that the object is created in the CoreData,
    /// therefore any deletion must be done explicitly.
    ///
    /// :returns: `NSManagedObject?`: The parsed object or nil if parse failed
    func retrieveJSONObject(data: JSON) -> NSManagedObject?{
        fatalError("getEntityName not implemented")
    }
    
    /// Clear all NSManagedObjects used by the endpoint
    func clearFromDatabase() {
        fatalError("clearFromCoreData not implemented")
    }
}



