import Foundation
import CoreData

class CoreDataStore: NSObject{
    static let sharedInstance = CoreDataStore()
    
    
    let storeName = "Model"
    let storeFilename = "malaria-ios.sqlite"
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // Get module name
        var moduleName: String = "malaria_ios"
        if inTestEnvironment() { moduleName = "malaria_iosTests" }
        
        // Get model
        let modelURL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!
        var model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        // Create entity copies
        var newEntities = [NSEntityDescription]()
        for (_, entity) in enumerate(model.entities) {
            let newEntity = entity.copy() as! NSEntityDescription
            newEntity.managedObjectClassName = "\(moduleName).\(entity.managedObjectClassName)"
            newEntities.append(newEntity)
        }
        
        // Set correct subentities
        for (_, entity) in enumerate(newEntities) {
            var newSubEntities = [NSEntityDescription]()
            for subEntity in entity.subentities! {
                for (_, entity) in enumerate(newEntities) {
                    if subEntity.name == entity.name {
                        newSubEntities.append(entity)
                    }
                }
            }
            entity.subentities = newSubEntities
        }
        
        // Set model
        model = NSManagedObjectModel()
        model.entities = newEntities
        
        return model
        }()
    
    lazy var persistentStoreCoordinator: RKManagedObjectStore? = {
        var coordinator = RKManagedObjectStore(managedObjectModel: self.managedObjectModel)
        self.objectManager!.managedObjectStore = coordinator
        
        coordinator.createPersistentStoreCoordinator()
        
        var storePath: NSString = RKApplicationDataDirectory().stringByAppendingPathComponent(self.storeFilename)
    
        var e: NSError?
        coordinator.addSQLitePersistentStoreAtPath(storePath as String, fromSeedDatabaseAtPath: nil, withConfiguration: nil,
            options: [
                NSInferMappingModelAutomaticallyOption: true,
                NSMigratePersistentStoresAutomaticallyOption: true
            ], error: &e)
            
        if(e != nil){
                var error: NSError? = nil
                coordinator = nil
                // Report any error we got.
                let dict = NSMutableDictionary()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
                Logger.Error("Serious error \(error), \(error!.userInfo)")
                abort()
        }
        
        coordinator.createManagedObjectContexts()
        coordinator.managedObjectCache = RKInMemoryManagedObjectCache(managedObjectContext: coordinator.persistentStoreManagedObjectContext)
        
        return coordinator
        }()
    
    
    lazy var objectManager: RKObjectManager? = {
        let objectManager: RKObjectManager = RKObjectManager(baseURL: NSURL(string: Endpoints.BaseUrl.rawValue))
        objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
        
        let username = "TestUser"
        let password = "password"
        
        objectManager.HTTPClient.setAuthorizationHeaderWithUsername(username, password: password)
        objectManager.HTTPClient.setDefaultHeader("whatIWantForChristmas", value: "You")
       
        // set up the base64-encoded credentials
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        objectManager.HTTPClient.setDefaultHeader("CuteHeader", value: "Basic \(base64LoginString)")
        
        objectManager.HTTPClient.allowsInvalidSSLCertificate = true
        
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        return objectManager
        }()
}