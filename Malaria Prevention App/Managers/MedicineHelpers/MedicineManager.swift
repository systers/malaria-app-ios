import Foundation

/// Manages `Medicine` core data instances

class MedicineManager: CoreDataContextManager {
  
  override init(context: NSManagedObjectContext) {
    super.init(context: context)
  }
  
  /// Clears instance of Medicines from the CoreData
  
  func clearCoreData() {
    Medicine.clear(Medicine.self, context: context)
    CoreDataHelper.sharedInstance.saveContext(context)
    UserSettingsManager.UserSetting.didConfigureMedicine.removeKey()
  }
  
  /**
   Register a new medicine with a name and a interval (e.g. 1 for daily and 7 for weekly).
   
   - parameter name: The name of the medicine.
   - parameter interval: The reminding time inverval for the medicine.
   
   - returns: `true` if success. `false` if not.
   */
  
  func registerNewMedicine(name: String,
                           interval: Int) -> Bool {
    if getMedicine(name) != nil {
      return false
    }
    
    let medicine = Medicine.create(Medicine.self, context: context)
    medicine.name = name
    medicine.interval = max(1, interval)
    
    medicine.achievementManager.defineAchievements()

    CoreDataHelper.sharedInstance.saveContext(context)
    
    return true
  }
  
  /**
   Retuns the current medicine being tracked (if any)
   
   - returns: The current medicine.
   */
  
  func getCurrentMedicine() -> Medicine? {
    let predicate = NSPredicate(format: "isCurrent == %@", true)
    return Medicine.retrieve(Medicine.self, predicate: predicate, fetchLimit: 1, context: context).first
  }
  
  /**
   Returns a specified medicine
   
   - parameter name: Name of pill, case sensitive.
   - returns: The medicine.
   */
  
  func getMedicine(name: String) -> Medicine? {
    let predicate = NSPredicate(format: "name == %@", name)
    return Medicine.retrieve(Medicine.self, predicate: predicate, fetchLimit: 1, context: context).first
  }
  
  /**
   Retuns all medicines registered.
   
   - returns: An array with all the medicines.
   */
  
  func getRegisteredMedicines() -> [Medicine] {
    return Medicine.retrieve(Medicine.self, context: self.context)
  }
  
  /**
   Sets the specified pill as current.
   
   - parameter name: Name of the pill, case sensitive.
   */
  
  func setCurrentPill(name: String) {
    if let m = getCurrentMedicine() {
      m.isCurrent = false
    } else {
      Logger.Error("No current pill found!")
    }
    
    Logger.Info("Setting \(name) as default")
    getMedicine(name)!.isCurrent = true
    
    CoreDataHelper.sharedInstance.saveContext(context)
    NSNotificationEvents.dataUpdated(nil)
  }
}