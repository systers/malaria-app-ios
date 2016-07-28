import Foundation

/// Class that handles all the achievements related to the Rapid Fire Game.

class RapidFireAchievementManager: NSObject {
  static let sharedInstance = RapidFireAchievementManager()
  
  private var game: RapidFireGame?
  private let achievementManager = AchievementManager.sharedInstance
  
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
    defineFlawlessGame()
  }
  
  /**
   Flawless Game.
   
   Finish the game without any wrong answers.
   */
  
  private func defineFlawlessGame() {
    Achievement.define(Constants.Achievements.RapidFireGame.FlawlessGame,
                       description: "Finish a Rapid Fire game without picking any wrong answer.",
                       tag: Constants.Achievements.Tags.Games)
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
      achievementManager.unlock(achievement: Constants.Achievements.RapidFireGame.FlawlessGame)
    }
  }
}