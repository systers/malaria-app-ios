class SyncManager {
    static let sharedInstance = SyncManager()
    var endpoints: [Endpoint] = []
    
    init(){
        Logger.Info("Registering")
        endpoints.append(ApiEndpoint())
        endpoints.map({ self.registerMapping($0) })
    }
    
    func syncAll(){
        endpoints.map({self.remoteFetch($0)})
    }
    
    private func remoteFetch(endpoint: Endpoint){
        
        //TODO: Check internet connection before doing request
        let cds = CoreDataStore.sharedInstance
        let cdh = CoreDataHelper.sharedInstance
        
        
        var requestUrl = cds.objectManager!.requestWithObject(
            nil,
            method: RKRequestMethod.GET,
            path: endpoint.path,
            parameters: endpoint.parameters())
        
        cds.objectManager!.getObjectsAtPath(
            endpoint.path,
            parameters: endpoint.parameters(),
            success:
            {
                (RKObjectRequestOperation, RKMappingResult) -> Void in
                
                println(RKObjectRequestOperation.description)
                Logger.Info("Success");
            },
            failure: {
                (RKObjectRequestOperation, error) -> Void in
                
                Logger.Error("Error: \(error.description)")
                println(RKObjectRequestOperation.HTTPRequestOperation.description)
                
            })
    }
    
    private func registerMapping(endpoint: Endpoint) {
        let responseDescriptor = RKResponseDescriptor(
            mapping: endpoint.mapping,
            method: RKRequestMethod.GET,
            pathPattern: endpoint.path,
            keyPath: nil,
            statusCodes: NSIndexSet(index: 200))
        CoreDataStore.sharedInstance.objectManager!.addResponseDescriptor(responseDescriptor)
    }
    
    
    
}