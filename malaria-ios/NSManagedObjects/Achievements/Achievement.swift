import Foundation
import CoreData

/// A general feat that a user can unlock using the application thoroughly.

class Achievement: NSManagedObject {

  /**
   Defines an achievement with a name, description and tag.
   */
  
  static func define(name: String,
                     description: String,
                     tag: String) -> Achievement? {
    
    let achievementManager = AchievementManager.sharedInstance
    
    if achievementManager.checkForDuplicateAchievements(name) {
      return nil
    }
    
    let achievement = Achievement.create(Achievement.self,
                                         context: achievementManager.context)
    
    achievement.isUnlocked = false
    achievement.name = name
    achievement.tag = tag
    achievement.desc = description
    
    CoreDataHelper.sharedInstance.saveContext(achievementManager.context)
    
    Logger.Info("Created the \(name) achievement.")
    
    return achievement
  }
}