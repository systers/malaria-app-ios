import Foundation

extension Medicine {
  
  /// - returns: The medicine interval.
  
  var interval: Int {
    get {
      return Int(internalInterval)
    }
    set {
      internalInterval = Int64(newValue)
    }
  }
  
  /// - returns: The current number of pills of this medicine.

  var currentStock: Int {
    get {
      return Int(remainingMedicine)
    }
    set {
      remainingMedicine = Int64(newValue)
    }
  }
  
  /// - returns: An object responsible for computing the statistics.
  
  var stats: MedicineStats {
    return MedicineStats(medicine: self)
  }
  
  /// - returns: An object responsible for handling the registries.
  
  var registriesManager: RegistriesManager {
    return RegistriesManager(medicine: self)
  }
  
  /// - returns: An object responsible for handling the notifications.
  
  var notificationManager: MedicineNotificationsManager{
    return MedicineNotificationsManager(medicine: self)
  }
  
  /// - returns: An object responsible for handling the user's remaining pills.
  
  var medicineStockManager: MedicineStockManager {
    return MedicineStockManager(medicine: self)
  }
  
  /**
   - returns: An object responsible for handling achievements
   related to the medicine.
   */
  
  var achievementManager: MedicineAchievementManager {
    return MedicineManagerProvider.sharedInstance.getManagerFor(self)
  }
}