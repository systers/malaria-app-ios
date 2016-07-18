import Foundation

/// Class that handles all the achievements related to the Medicine object.

class MedicineAchievementManager: CoreDataContextManager {
  
  private let medicine: Medicine
  private let achievementManager = AchievementManager.sharedInstance

  /// The init() method of the MedicineAchievementManager.
  
  init(medicine: Medicine) {
    self.medicine = medicine
    super.init(context: medicine.managedObjectContext!)
  }
  
  func defineAchievements() {
    defineStayingSafe()
  }
  
  /**
   Staying safe.
   
   Achievement that unlocks if the user takes his first pill.
   */

  private func defineStayingSafe() {
    achievementManager.defineProperty("First medicine taken.",
                                      initialValue: medicine.registriesManager.getRegistries().count,
                                      activationMode: ">",
                                      value: 0)
        
    achievementManager.defineAchievement("Staying safe.",
                                         description: "Take your first medicine.",
                                         propertyNames: ["First medicine taken."],
                                         tag: "Pills")
  }

}