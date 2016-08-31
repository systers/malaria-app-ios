import Foundation

/// Class that handles all the achievements related to the Rapid Fire Game.

class RapidFireAchievementManager: NSObject, SpecializedAchievementManager {
  static let sharedInstance = RapidFireAchievementManager()
  
  static let FlawlessGame = NSLocalizedString("Flawless game",
                                              comment: "The achievement name.")

  private let FlawlessGameDescription =
  NSLocalizedString("Finish a Rapid Fire game without picking any wrong answer.",
                    comment: "The achievement description.")
  
  private var game: RapidFireGame?
  private let achievementManager = AchievementManager.sharedInstance
  
  override init() {
    super.init()
        
    NSNotificationEvents.ObserveRFGameFinished(self,
                                               selector: #selector(checkAchievements))
  }
  
  deinit {
    NSNotificationEvents.UnregisterAll(self)
  }
}

// MARK: Declaring Achievements.

extension RapidFireAchievementManager {
  
  func defineAchievements() {
    defineFlawlessGame()
  }
  
  /**
   Flawless Game.
   
   Finish the game without any wrong answers.
   */
  private func defineFlawlessGame() {
    Achievement.define(RapidFireAchievementManager.FlawlessGame,
                       description: FlawlessGameDescription,
                       tag: Constants.Achievements.GamesTag)
  }
}

// MARK: Checking Achievements.

extension RapidFireAchievementManager {
  
  func checkAchievements(notification: NSNotification) {
    let dict = notification.userInfo as! [String : RapidFireGame]?
    game = dict!["game"]
    
    checkFlawlessGame()
  }
  
  private func checkFlawlessGame() {
    if game!.maximumScore == game!.numberOfLevels {
      achievementManager.unlock(achievement: RapidFireAchievementManager.FlawlessGame)
    }
  }
}