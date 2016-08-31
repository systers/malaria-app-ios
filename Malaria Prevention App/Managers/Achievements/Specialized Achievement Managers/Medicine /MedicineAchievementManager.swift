import Foundation

/// Class that handles all the achievements related to the Medicine object.

class MedicineAchievementManager: NSObject, SpecializedAchievementManager {
  
  static let StayingSafe = NSLocalizedString("Staying safe", comment: "Achievement name")
  private let StayingSafeDescription = NSLocalizedString("Take your first medicine.",
                                                         comment: "Achievement description.")
  
  private var medicine: Medicine
  private let achievementManager = AchievementManager.sharedInstance
  private var context: NSManagedObjectContext!

  init(medicine: Medicine) {
    self.medicine = medicine
    self.context = medicine.managedObjectContext
    
    super.init()
    
    NSNotificationEvents.ObserveDataUpdated(self,
                                            selector: #selector(checkAchievements))
  }
  
  deinit {
    NSNotificationEvents.UnregisterAll(self)
  }
  
}

// MARK: Declaring Achievements.

extension MedicineAchievementManager {
  
  func defineAchievements() {
    defineStayingSafe()
  }
  
  /**
   Staying safe.
   
   Achievement that unlocks if the user takes the first pill.
   */
  
  private func defineStayingSafe() {
    Achievement.define(MedicineAchievementManager.StayingSafe,
                       description: StayingSafeDescription,
                       tag: Constants.Achievements.PillsTag)
  }
}

// MARK: Checking Achievements.

extension MedicineAchievementManager {
  
  func checkAchievements(notification: NSNotification) {
    checkStayingSafe()
  }
  
  private func checkStayingSafe() {
    context = CoreDataHelper.sharedInstance.createBackgroundContext()
    let medicineManager = MedicineManager(context: context)
    
    let medicine = medicineManager.getMedicine(self.medicine.name)
    
    if medicine?.registriesManager.lastPillDate() != nil {
      achievementManager.unlock(achievement: MedicineAchievementManager.StayingSafe)
    }
  }
}