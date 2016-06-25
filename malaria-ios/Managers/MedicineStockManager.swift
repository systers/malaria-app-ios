import Foundation

class MedicineStockManager: CoreDataContextManager {
  
  private let medicine: Medicine
  
  /// The init() method of the MedicineStockManager.
  
  init(medicine: Medicine) {
    self.medicine = medicine
    super.init(context: medicine.managedObjectContext!)
  }
  
  /// A method that updates the current medicine stock.
  
  func updateStock(tookMedicine: Bool) {
    Logger.Info("Updating stock.")
    medicine.remainingMedicine += tookMedicine ? -1 : 1
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  /// A wrapper method of addRegistry() that will first check whether the user can modify / add an entry
  /// before adding it.
  
  func addRegistry(date: NSDate, tookMedicine: Bool, modifyEntry: Bool = false) -> Bool {
    
    // Check if the user modifies a date, after the last refill, in the calendar
    // if so, modify the entry and the current stock
    // else, only modify the entry.
    
    let lastStockRefill = medicine.lastStockRefill ?? NSDate()
    
    if date.sameDayAs(lastStockRefill) || date > lastStockRefill {
      
      // Check if the user has enough pills to say that he took the pill
      if !medicine.medicineStockManager.hasEnoughPills() && tookMedicine {
        return false
      }
      
      let addRegistryResult = medicine.registriesManager.addRegistry(date, tookMedicine: tookMedicine, modifyEntry: modifyEntry)
      
      // Only update stock if the entry was added successfully.
      if addRegistryResult.registryAdded && addRegistryResult.noOtherEntryFound {
        updateStock(tookMedicine)
      }
      
      return addRegistryResult.registryAdded
    }
    
    let addRegistryResult = medicine.registriesManager.addRegistry(date, tookMedicine: tookMedicine, modifyEntry: modifyEntry)
    
    return addRegistryResult.registryAdded
  }
  
  /// A method which checks if the user has enough pills on the moment (current context).
  
  func hasEnoughPills() -> Bool {
    // Check if the user has enough pills left
    if medicine.remainingMedicine <= 0 {
      Logger.Warn("User doesn't have enough pills to add an entry.")
      return false
    }
    
    return true
  }
}