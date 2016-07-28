import Foundation

/// Abstract class for all managers

class CoreDataContextManager {
  
    /// Associated NSManagedObjectContext, shared with subclasses
    let context: NSManagedObjectContext
    
    /// Init
    init(context: NSManagedObjectContext){
        self.context = context
    }
}