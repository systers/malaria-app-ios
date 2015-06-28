import Alamofire
import SwiftyJSON

class SyncManager {
    static let sharedInstance = SyncManager()
    
    let user = "TestUser"
    let password = "password"
    
    init(){
        // set up the base64-encoded credentials
        let loginString = NSString(format: "%@:%@", user, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!.updateValue("Basic \(base64LoginString)", forKey: "Authorization")
    }
    
    var endpoints: [String : Endpoint] = [
        EndpointType.Api.path() : ApiEndpoint(),
        EndpointType.Posts.path() : PostsEndpoint(),
        EndpointType.Regions.path() : RegionsEndpoint(),
        EndpointType.Volunteer.path() : VolunteersEndpoint(),
        EndpointType.Sectors.path() : SectorsEndpoint(),
        EndpointType.Projects.path() : ProjectsEndpoint(),
        EndpointType.Ptposts.path() : PtPostsEndpoint(),
        EndpointType.Goals.path() : GoalsEndpoint(),
        EndpointType.Indicators.path() : IndicatorsEndpoint(),
        EndpointType.Activity.path() : ActivitiesEndpoint(),
        EndpointType.Cohort.path() : CohortsEndpoint(),
        EndpointType.Outcomes.path() : OutcomesEndpoint(),
        EndpointType.Objectives.path() : ObjectivesEndpoint(),
        EndpointType.Measurement.path() : MeasurementsEndpoint(),
        EndpointType.Revposts.path() : RevPostsEndpoint(),
        EndpointType.Outputs.path() : OutputsEndpoint()
    ]
    
    /// Syncs a specific endpoint
    ///
    /// :param: `String`: full path
    /// :param: `Bool`: Save context after success
    /// :param: `((url: String, error: NSError?)->())?`: failure Handler (default nil)
    /// :param: `((url: String, object: NSManagedObject)->())?`: success Handler (default nil)
    func sync(path: String, save: Bool = false, failureHandler: ((url: String, error: NSError?)->())? = nil, successHandler: ((url: String, object: NSManagedObject)->())? = nil){
        
        func expandedSuccessHandler(url: String, object: NSManagedObject){
            if let success = successHandler{
                success(url: url, object: object)
            }
            
            if (save){
                Logger.Info("Saving to coreData")
                CoreDataHelper.sharedInstance.saveContext()
            }
        }
        
        if let endpoint = endpoints[path]{
            remoteFetch(endpoint, failureHandler: failureHandler, successHandler: expandedSuccessHandler)
        }else{
            Logger.Error("Bad path provided to sync")
            if let failure = failureHandler{
                failure(url: path, error: nil)
            }
        }
    }
    
    /// Syncs every endpoint
    ///
    /// Runs the specified completition handler after syncing every endpoint.
    ///
    /// :param: `(()->())?`: completition handler (default nil)
    func syncAll(completitionHandler: (()->())? = nil){
        var count = endpoints.count
        func successHandler(url: String, object: NSManagedObject){
            CoreDataHelper.sharedInstance.saveContext()
            
            count--
            if(count == 0){
                Logger.Info("Sync complete")
                completitionHandler?()
            }
        }
        
        for (path, endpoint) in endpoints{
            sync(path, successHandler: successHandler)
        }
    }
    
    private func remoteFetch(endpoint: Endpoint, save: Bool = false, failureHandler: ((url: String, error: NSError?)->())? = nil, successHandler: ((url: String, object: NSManagedObject)->())? = nil){
        
        Alamofire.request(.GET, endpoint.path, parameters: endpoint.parameters)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    Logger.Error("Error at \(endpoint.path)): \(error!)")
                    failureHandler?(url: endpoint.path, error: nil)
                }
                else {
                    Logger.Info("Connected to \(endpoint.path)")
                    endpoint.clearFromDatabase()
                    if let objectMapped = endpoint.retrieveJSONObject(JSON(json!)){
                        successHandler?(url: endpoint.path, object: objectMapped)
                    }else{
                        Logger.Error("Error parsing \(endpoint.path)")
                        failureHandler?(url: endpoint.path, error: nil)
                    }
                }
            }
    }
}