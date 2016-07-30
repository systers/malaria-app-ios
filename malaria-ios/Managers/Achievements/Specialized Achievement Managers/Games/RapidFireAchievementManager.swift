import Foundation

/// Class that handles all the achievements related to the Rapid Fire Game.

class RapidFireAchievementManager: NSObject, SpecializedAchievementManager {
  static let sharedInstance = RapidFireAchievementManager()
  
  private static let FlawlessGame = "Flawless game"
  private let FlawlessGameDescription =
  "Finish a Rapid Fire game without picking any wrong answer."
  
  private var game: RapidFireGame?
  private let achievementManager = AchievementManager.sharedInstance
  
  let tag = "Games"

  override init() {
    super.init()
    
    defineAchievements()
    
    NSNotificationEvents.ObserveRFGameFinished(self,
                                               selector: #selector(checkAchievements))
  }
  
  deinit {
    NSNotificationEvents.UnregisterAll(self)
  }
}

// MARK: Declaring Achievements

extension RapidFireAchievementManager {
  
  func defineAchievements() {
    achievementManager.addTag(tag)

    defineFlawlessGame()
  }
  
  /**
   Flawless Game.
   
   Finish the game without any wrong answers.
   */
  
  private func defineFlawlessGame() {
    Achievement.define(RapidFireAchievementManager.FlawlessGame,
                       description: FlawlessGameDescription,
                       tag: tag)
  }
}

// MARK: Checking Achievements

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