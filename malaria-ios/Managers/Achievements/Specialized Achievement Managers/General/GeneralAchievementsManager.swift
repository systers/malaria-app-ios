import Foundation

/// Class that handles the rest of the achievements throughout the app.

class GeneralAchievementsManager: NSObject, SpecializedAchievementManager {
  static let sharedInstance = GeneralAchievementsManager()
  
  private let PlanFirstTripDescription = "Plan your first trip."
  
  private let achievementManager = AchievementManager.sharedInstance
  
  let tag = "General"
  
  private override init() {
    super.init()
    
    defineAchievements()
    
    achievementManager.addTag(tag)
    
    NSNotificationEvents.ObserveTripPlanned(self,
                                            selector: #selector(checkAchievements))
  }
  
  deinit {
    NSNotificationEvents.UnregisterAll(self)
  }
}

// MARK: Declaring Achievements

extension GeneralAchievementsManager {
  
  func defineAchievements() {
    defineFirstTrip()
  }
  
  /**
   First Trip.
   
   User plans his first trip.
   */
  
  private func defineFirstTrip() {
    Achievement.define(Constants.Achievements.General.PlanFirstTrip,
                       description: PlanFirstTripDescription,
                       tag: tag)
  }
}

// MARK: Checking Achievements

extension GeneralAchievementsManager {
  
  func checkAchievements(notification: NSNotification) {
    checkFirstTrip()
  }
  
  private func checkFirstTrip() {
    let context = CoreDataHelper.sharedInstance.createBackgroundContext()!
    
    if TripsManager(context: context).getTrip() != nil {
      achievementManager.unlock(achievement: Constants.Achievements.General.PlanFirstTrip)
    }    
  }
}