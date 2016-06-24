import Foundation

class MedicineStockManager: CoreDataContextManager {
  
  private let medicine: Medicine
  
  /// Init
  init(medicine: Medicine) {
    self.medicine = medicine
    super.init(context: medicine.managedObjectContext!)
  }
  
  ///
  func updateStock(tookMedicine: Bool) {
    Logger.Info("Updating stock.")
    medicine.remainingMedicine += tookMedicine ? -1 : 1
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  func addRegistry(date: NSDate, tookMedicine: Bool, modifyEntry: Bool = false) -> Bool {
    
    // Check if the user modifies a date, after the last refill, in the calendar
    // if so, modify the entry and the current stock
    // else, only modify the entry
    let lastStockRefill = medicine.lastStockRefill ?? NSDate()
    
    if date.sameDayAs(lastStockRefill) || date > lastStockRefill {
      
      // Check if the user has enough pills to say that he took the pill
      if !medicine.medicineStockManager.hasEnoughPills() && tookMedicine {
        return false
      }
      
      let registryAdded = medicine.registriesManager.addRegistry(date, tookMedicine: tookMedicine, modifyEntry: modifyEntry)
      
      // Only update stock if the entry was added successfully
      if registryAdded.0 && registryAdded.noOtherEntryFound {
        updateStock(tookMedicine)
      }
      
      return registryAdded.0
    }
    
    let registryAdded = medicine.registriesManager.addRegistry(date, tookMedicine: tookMedicine, modifyEntry: modifyEntry)
    
    return registryAdded.0
  }
  
  func hasEnoughPills() -> Bool {
    // Check if the user has enough pills left
    if medicine.remainingMedicine <= 0 {
      Logger.Warn("User doesn't have enough pills to add an entry.")
      return false
    }
    
    return true
  }
}