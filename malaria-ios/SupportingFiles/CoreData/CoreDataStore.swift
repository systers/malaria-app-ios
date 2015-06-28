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
        var moduleName: String = inTestEnvironment ? "malaria_iosTests" : "malaria_ios"
        
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
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.storeFilename)
    
        var error: NSError?
        if coordinator!.addPersistentStoreWithType(
            NSSQLiteStoreType,
            configuration: nil,
            URL: url,
            options: [
                NSInferMappingModelAutomaticallyOption: true,
                NSMigratePersistentStoresAutomaticallyOption: true
            ], error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "PERSISTENT_CONFIGURATION", code: 9999, userInfo: dict as [NSObject : AnyObject])
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }

        return coordinator
        }()
}