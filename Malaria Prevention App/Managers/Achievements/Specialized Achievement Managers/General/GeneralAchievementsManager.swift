import Foundation

/// Class that handles general achievements throughout the app.

class GeneralAchievementsManager: NSObject, SpecializedAchievementManager {
  static let sharedInstance = GeneralAchievementsManager()
  
  static let PlanFirstTrip = NSLocalizedString("First Trip",
                                               comment: "Achievement name.")
  private let PlanFirstTripDescription = NSLocalizedString("Plan your first trip.",
                                                           comment: "Achievement description.")
  
  private let achievementManager = AchievementManager.sharedInstance
  
  private var context: NSManagedObjectContext!

  private override init() {
    super.init()
    
    context = CoreDataHelper.sharedInstance.createBackgroundContext()!
    
    NSNotificationEvents.ObserveTripPlanned(self,
                                            selector: #selector(checkAchievements))
  }
  
  deinit {
    NSNotificationEvents.UnregisterAll(self)
  }
}

// MARK: Declaring Achievements.

extension GeneralAchievementsManager {
  
  func defineAchievements() {
    defineFirstTrip()
  }
  
  /**
   First Trip.
   
   User plans his first trip.
   */
  
  private func defineFirstTrip() {
    Achievement.define(GeneralAchievementsManager.PlanFirstTrip,
                       description: PlanFirstTripDescription,
                       tag: Constants.Achievements.GeneralTag)
  }
}

// MARK: Checking Achievements

extension GeneralAchievementsManager {
  
  func checkAchievements(notification: NSNotification) {
    checkFirstTrip()
  }
  
  private func checkFirstTrip() {    
    if TripsManager(context: context).getTrip() != nil {
      achievementManager.unlock(achievement: GeneralAchievementsManager.PlanFirstTrip)
    }    
  }
}