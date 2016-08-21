import Foundation

/**
 Medicine containing name, interval
 and if is set as the current one (among other fields).
 */

class Medicine: NSManagedObject {
  
  /// - returns: The medicine last stock refill date.
  
  var lastStockRefill: NSDate {
    get {
      return NSDate(timeIntervalSinceReferenceDate: internalLastStockRefill)
    }
    set {
      internalLastStockRefill = newValue.timeIntervalSinceReferenceDate
    }
  }
  
  /// - returns: The medicine notification time.
  
  var notificationTime: NSDate? {
    get {
      return NSDate(timeIntervalSinceReferenceDate: internalNotificationTime)
    }
    set {
      internalNotificationTime = (newValue ?? NSDate()).timeIntervalSinceReferenceDate
    }
  }
  
  /// - returns: How often the pill should be taken.
  
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