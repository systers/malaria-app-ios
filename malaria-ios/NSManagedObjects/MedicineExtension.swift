import Foundation

extension Medicine {
  /// - returns: `Int`: medicine interval
  var interval: Int {
    get {
      return Int(internalInterval)
    }
    set {
      internalInterval = Int64(newValue)
    }
  }
  
  /// Returns an object responsible for computing the statistics.
  var stats: MedicineStats {
    return MedicineStats(medicine: self)
  }
  
  /// Returns an object responsible for handling the registries.
  var registriesManager: RegistriesManager{
    return RegistriesManager(medicine: self)
  }
  
  /// Returns an object responsible for handling the notifications.
  var notificationManager: MedicineNotificationsManager{
    return MedicineNotificationsManager(medicine: self)
  }
  
  /// Returns an object responsible for handling the user's remaining pills.
  var medicineStockManager: MedicineStockManager {
    return MedicineStockManager(medicine: self)
  }
  
  /**
   Returns an object responsible for handling achievements
   related to the medicine.
   */
  var achievementManager: MedicineAchievementManager {
    return MedicineManagerProvider.sharedInstance.getManagerFor(self)
  }
}