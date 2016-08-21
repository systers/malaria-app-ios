import Foundation

class MedicineStockManager: CoreDataContextManager {
  
  private let medicine: Medicine
  
  /**
   The init() method of the MedicineStockManager.
   
   - parameter medicine: The pill that this class should manage.
   */
  
  init(medicine: Medicine) {
    self.medicine = medicine
    super.init(context: medicine.managedObjectContext!)
  }
  
  /**
   A method that updates the current medicine stock.
   
   - parameter tookMedicine: Indicates whether we need to increment or decrement
   the medicine's stock.
   */
  
  func updateStock(tookMedicine: Bool) {
    Logger.Info("Updating stock.")
    medicine.currentStock += tookMedicine ? -1 : 1
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  /**
   Another method to update the current medicine stock.
   
   - parameter newStock: replaces the current medicine's stock with this value.
   */
  
  func updateStock(newStock: Int) {
    medicine.currentStock = newStock
    CoreDataHelper.sharedInstance.saveContext(context)
    NSNotificationEvents.dataUpdated(nil)
  }
  
  /**
   A wrapper method of addRegistry() that will first check whether the user can modify / add an entry
   before adding it.
   
   - parameter date: The date when we want to add the new entry.
   - parameter tookMedicine: Whether or not the user took the medicine.
   - parameter modifyEntry: Whether we want to overwrite the value of not.
   
   - returns: If the registry was added successfully or not.
   */
  
  func addRegistry(date: NSDate, tookMedicine: Bool, modifyEntry: Bool = false) -> Bool {
    
    // Check if the user modifies a date, after the last refill, in the calendar
    // if so, modify the entry and the current stock
    // else, only modify the entry.
    
    let lastStockRefill = medicine.lastStockRefill ?? NSDate()
    
    if date.sameDayAs(lastStockRefill) || date > lastStockRefill {
      
      // Check if the user has enough pills to say that he took the pill.
      if !medicine.medicineStockManager.hasEnoughPills() && tookMedicine {
        return false
      }
      
      let addRegistryResult = medicine.registriesManager.addRegistry(date, tookMedicine: tookMedicine, modifyEntry: modifyEntry)
      
      // Only update stock if the entry was added successfully and we replace another entry (after the refill date)
      // or when we just added an entry which was a Yes (in the No case, there will be no updateStock).
      
      if (addRegistryResult.registryAdded && addRegistryResult.otherEntriesFound)
        || (addRegistryResult.registryAdded && !addRegistryResult.otherEntriesFound
          && tookMedicine) {
        updateStock(tookMedicine)
      }
      
      return addRegistryResult.registryAdded
    }
    
    let addRegistryResult = medicine.registriesManager.addRegistry(date, tookMedicine: tookMedicine, modifyEntry: modifyEntry)
    
    return addRegistryResult.registryAdded
  }
  
  /// A method which checks if the user has enough pills on the moment (current context).
  
  func hasEnoughPills() -> Bool {
    // Check if the user has enough pills left.
    if medicine.currentStock <= 0 {
      Logger.Warn("User doesn't have enough pills to add an entry.")
      return false
    }
    
    return true
  }
}