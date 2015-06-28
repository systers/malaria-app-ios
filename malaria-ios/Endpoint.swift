class Endpoint{
    
    func parameters() -> [String: String] { return ["format": "json"] }
    
    var entityName: String { get { fatalError("getEntityName not implemented")} }
    var path: String { get { fatalError("getEndpoint not implemented")} }
    var mapping: RKEntityMapping { get { fatalError("getMapping not implemented")} }
    
    func clearFromDatabase() {
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        let fetch = NSFetchRequest(entityName: entityName)
        fetch.includesPropertyValues = false //only fetch the managedObjectID
        
        var result = context.executeFetchRequest(fetch, error: nil) as! [NSManagedObject]
        result.map(context.deleteObject)
        
        CoreDataHelper.sharedInstance.saveContext(context)
    }
}



