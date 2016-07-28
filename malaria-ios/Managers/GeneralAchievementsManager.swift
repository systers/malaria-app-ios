import Foundation

/// Class that handles all the achievements related to the Rapid Fire Game.

class GeneralAchievementsManager: NSObject {
  static let sharedInstance = GeneralAchievementsManager()

  private let achievementManager = AchievementManager.sharedInstance
  
  private override init() {
    super.init()
    
    defineAchievements()

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
                       description: "Plan your first trip!",
                       tag: Constants.Achievements.Tags.General)
  }
}

// MARK: Checking Achievements

extension GeneralAchievementsManager {
  
  func checkAchievements() {
    checkFlawlessGame()
  }
  
  private func checkFlawlessGame() {
    let context = CoreDataHelper.sharedInstance.createBackgroundContext()!
    
    if TripsManager(context: context).getTrip() != nil {
      achievementManager.unlock(achievement: Constants.Achievements.General.PlanFirstTrip)
    }    
  }
}