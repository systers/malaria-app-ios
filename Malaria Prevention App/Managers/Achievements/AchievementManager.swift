import UIKit
import Toast_Swift

/// Handles general achievement logic throughout the app.

class AchievementManager: CoreDataContextManager {
  static var sharedInstance = AchievementManager(
    context: CoreDataHelper.sharedInstance.createBackgroundContext()!
  )
  
  override init(context: NSManagedObjectContext) {
    super.init(context: context)
    
    clearAchievements()
    
    addTag(Constants.Achievements.GeneralTag)
    addTag(Constants.Achievements.PillsTag)
    addTag(Constants.Achievements.GamesTag)
  }
  
  typealias AchievementObject = (tag: String, achievements: [Achievement])
  
  private var tags: Set<String> = []
  
  // MARK: Properties.
  
  private var achievements: [Achievement] {
    return Achievement.retrieve(Achievement.self, context: context)
  }
  
  // MARK: Methods.
  
  /// Add a new tag, by which the achievements to be filtered.
  
  func addTag(tag: String) {
    tags.insert(tag)
  }
  
  /**
   Retrieves all the achievements for all defined tags.
   
   - returns: An array of achievements separated by their tag
   in the for of an `AchievementObject`.
   */
  
  func getAchievements() -> [AchievementObject] {
    var results: [AchievementObject] = []
    
    for tag in tags {
      let achievementObject = AchievementObject(tag, achievements.filter { $0.tag == tag })
      
      if achievementObject.achievements.count > 0 {
        results.append(achievementObject)
      }
    }
    
    return results
  }
  
  /// Checks whether an achievement is already defined.
  
  func checkForDuplicateAchievements(achievementName: String) -> Bool {
    for achievement in achievements {
      if achievement.name! == achievementName {
        return true
      }
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
    ToastHelper.makeToast(String.localizedStringWithFormat(
      NSLocalizedString("Achievement %@ unlocked",
        comment: "Tells the user that the achievement is unlocked."), name))
    
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  // Check if the achievement was already unlocked and return.
  
  func isAchievementUnlocked(achievement name: String) -> Bool {
    guard let achievement = achievements.filter({ $0.name == name }).first else {
      Logger.Error("Tried to unlock an achievement that doesn't exist.")
      return false
    }
    
    return achievement.isUnlocked
  }
  
  /// Clears all the achievements in Core Data.
  
  func clearAchievements() {
    Achievement.clear(Achievement.self, context: context)
  }
}