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
        let environment = NSProcessInfo.processInfo().environment as! [String : AnyObject]
        let isTest = (environment["XCInjectBundle"] as? String)?.pathExtension == "xctest"
        if isTest { logger("@@@In test environment@@@"); moduleName = "malaria_iosTests" }
        
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
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator.addSQLitePersistentStoreAtPath(storePath as String, fromSeedDatabaseAtPath: nil, withConfiguration: nil,
            options: [
                NSInferMappingModelAutomaticallyOption: true,
                NSMigratePersistentStoresAutomaticallyOption: true
            ], error: nil) == nil {
                
                coordinator = nil
                // Report any error we got.
                let dict = NSMutableDictionary()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
                logger("Unresolved error \(error), \(error!.userInfo)")
                abort()
        }
        
        coordinator.createManagedObjectContexts()
        coordinator.managedObjectCache = RKInMemoryManagedObjectCache(managedObjectContext: coordinator.persistentStoreManagedObjectContext)
        
        return coordinator
        }()
    
    
    lazy var objectManager: RKObjectManager? = {
        
        let objectManager: RKObjectManager = RKObjectManager(baseURL: NSURL(string: "base_url"))
        objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
        
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        return objectManager
        }()
}