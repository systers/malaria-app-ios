import Foundation

/// Manages `NSManagedObjectContext`.

class CoreDataHelper: NSObject {
  static let sharedInstance = CoreDataHelper()
  
  /// Init.
  override init() {
    super.init()
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self,
                                   selector: #selector(contextDidSaveContext),
                                   name: NSManagedObjectContextDidSaveNotification,
                                   object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  private lazy var managedObjectContext: NSManagedObjectContext? = {
    let coordinator = CoreDataStore.sharedInstance.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  /**
   Creates a new background context with the mainContext as parent.
   Create background context to keep in sync with the database.
   
   - returns: The newly created context.
   */
  
  func createBackgroundContext() -> NSManagedObjectContext? {
    guard CoreDataStore.sharedInstance.persistentStoreCoordinator != nil else {
      return nil
    }
    
    let backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    backgroundContext.parentContext = self.managedObjectContext
    return backgroundContext
  }
  
  /**
   Saves the context.
   
   - parameter context: The context to be saved.
   */
  
  func saveContext (context: NSManagedObjectContext) {
    if context.hasChanges {
      do {
        try context.save()
      } catch let error as NSError {
        Logger.Error("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  
  /**
   Callback for multi-threading. Syncronizes the background context with the main context.
   Then the parent context, that has direct connection with persistent storage saves
   */
  
  func contextDidSaveContext(notification: NSNotification) {
    let sender = notification.object as! NSManagedObjectContext
    if sender != self.managedObjectContext {
      self.managedObjectContext!.performBlock {
        self.managedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
        self.saveContext(self.managedObjectContext!)
      }
    }
  }
}
