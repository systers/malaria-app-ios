import Foundation

class CoreDataHelper: NSObject {
    static let sharedInstance = CoreDataHelper()
    
    lazy var backgroundContext: NSManagedObjectContext? = {
        let coordinator = CoreDataStore.sharedInstance.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
        }()
    
    func saveContext (context: NSManagedObjectContext) {
        var error: NSError?
        if context.hasChanges && !context.save(&error) {
            Logger.Error("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }
    
    func saveContext () {
        self.saveContext( self.backgroundContext! )
    }
}
