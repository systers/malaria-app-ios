import UIKit
import Toast_Swift

/// Handles general achievement logic throughout the app.

class AchievementManager: CoreDataContextManager {
  static var sharedInstance = AchievementManager(
    context: CoreDataHelper.sharedInstance.createBackgroundContext()!
  )
  
  // MARK: Properties
  
  private var achievements: [Achievement] {
    let results = Achievement.retrieve(Achievement.self, context: context)
    return results
  }
  
  // MARK: Methods
  
  func getAchievements(withTag tag: String) -> [Achievement] {
    return achievements.filter { $0.tag == tag }
  }
  
  func checkForDuplicateAchievements(achievementName: String) -> Bool {
    for achievement in achievements where achievement.name == achievementName {
      return true
    }
    return false
  }
  
  func unlock(achievement name: String) {
    // Check if achievement already exists.
    guard let achievement = achievements.filter({ $0.name == name }).first else {
      Logger.Error("Tried to unlock an achievement that doesn't exist.")
      return
    }
    
    if isAchievementUnlocked(achievement: name) {
      return
    }
    
    // Unlock achievement.
    achievement.isUnlocked = true
    
    Logger.Info("Unlocked achievement: \(name)")
    
    // Show alert message.
    UIApplication.sharedApplication().keyWindow?.rootViewController?
      .view.makeToast("Achievement \"\(name)\" unlocked.",
                      duration: 3.0,
                      position: .Bottom)
    
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  // Check if the achievement was already unlocked and return.
  
  func isAchievementUnlocked(achievement name: String) -> Bool {
    guard let achievement = achievements.filter({ $0.name == name }).first else {
      Logger.Error("Tried to unlock an achievement that doesn't exist.")
      return false
    }
    
    return achievement.isUnlocked == true
  }
  
  func clearAchievements() {
    Achievement.clear(Achievement.self, context: context)
  }
}