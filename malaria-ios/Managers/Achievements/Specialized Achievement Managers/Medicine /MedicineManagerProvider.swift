import Foundation

/**
 Provides a `MedicineAchievementManager` for each `medicine`.
 
 It is used because we had to cache those achievements managers in order not
 to lose the observers inside them.
 */

class MedicineManagerProvider {
  static let sharedInstance = MedicineManagerProvider()
  
  // An object that caches each manager based on the pill name.
  var medicineAchievementManagers: [String: MedicineAchievementManager] = [:]
  
  func getManagerFor(medicine: Medicine) -> MedicineAchievementManager {
    
    // Check if a manager exists, if not, create one.
    guard let manager = medicineAchievementManagers[medicine.name] else {
      medicineAchievementManagers[medicine.name] = MedicineAchievementManager(medicine: medicine)
      return  medicineAchievementManagers[medicine.name]!
    }
    return manager
  }
}