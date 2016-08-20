import Foundation

/**
 Provides a `MedicineAchievementManager` for each `Medicine`.
 
 It is used because we had to cache those achievements managers in order not
 to lose the observers inside them.
 */

class MedicineManagerProvider {
  static let sharedInstance = MedicineManagerProvider()
  
  private let StoredDictionaryKey = "Medicine Achievement Managers Dictionary"
  
  // An object that caches each manager based on the pill.
  var currentMedicineManager: MedicineAchievementManager!
  
  func getManagerFor(medicine: Medicine) -> MedicineAchievementManager {
    
    //    // Check if a manager exists, if not, create one.
    //    guard let manager = medicineAchievementManagers[medicine] else {
    currentMedicineManager = MedicineAchievementManager(medicine: medicine)
    return currentMedicineManager
    //    }
    //
    //    return manager
  }
}