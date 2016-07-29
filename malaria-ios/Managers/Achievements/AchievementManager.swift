import UIKit
import Toast_Swift

/// Handles general achievement logic throughout the app.

class AchievementManager: CoreDataContextManager {
  static var sharedInstance = AchievementManager(
    context: CoreDataHelper.sharedInstance.createBackgroundContext()!
  )
  
  typealias AchievementObject = (sectionName: String, achievements: [Achievement])
  
  private var tags: [String]? = []
  
  // MARK: Properties
  
  private var achievements: [Achievement] {
    let results = Achievement.retrieve(Achievement.self, context: context)
    return results
  }
  
  // MARK: Methods
  
  func addTag(tag: String) {
    tags!.append(tag)
  }
  
  func getAchievements() -> [AchievementObject] {
    var results: [AchievementObject] = []
    
    for tag in tags! {
      let achievementObject = (tag, achievements.filter { $0.tag == tag })
      results.append(achievementObject)
    }
    
    return results
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
    ToastHelper.makeToast("Achievement \"\(name)\" unlocked.")
    
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