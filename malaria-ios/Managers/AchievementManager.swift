import Foundation

/// Handles general achievement logic throughout the app.

class AchievementManager {
  static let sharedInstance = AchievementManager()
  
  var context: NSManagedObjectContext! =
    CoreDataHelper.sharedInstance.createBackgroundContext()!
  
  private var achievements: [Achievement] {
    let fetchRequest = NSFetchRequest(entityName: "Achievement")
    
    do {
      let result = try context.executeFetchRequest(fetchRequest) as! [Achievement]
      return result as [Achievement]
    } catch let error as NSError {
      Logger.Error("Could not fetch \(error), \(error.userInfo)")
    }
    return []
  }
  
  /**
   Each achievement has it properties that needs to be fulfilled
   in order to unlock.
   */
  
  private var properties: [AchievementProperty] {
    let fetchRequest = NSFetchRequest(entityName: "AchievementProperty")
    
    do {
      let result = try context.executeFetchRequest(fetchRequest) as! [AchievementProperty]
      return result as [AchievementProperty]
    } catch let error as NSError {
      Logger.Error("Could not fetch \(error), \(error.userInfo)")
    }
    return []
  }
  
  func getAchievements(withTag tag: String) -> [Achievement] {
    return achievements.filter { $0.tag == tag }
  }
  
  func defineProperty(name: String,
                      initialValue: Int,
                      activationMode: String,
                      value: Int) {
    
    // Check for duplicate properties.
    for property in self.properties where property.name == name {
        return
    }
    
    let property = NSEntityDescription.insertNewObjectForEntityForName("AchievementProperty", inManagedObjectContext: context) as! AchievementProperty
    
    property.name = name
    property.activation = activationMode
    property.activationValue = value
    property.initialValue = initialValue
    
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  /**
   Defines an achievement with a name, tag and defined properties name that it will use.
   
   Example: defineAchievement("Bounty Hunting",
   tag: "Games",
   ["Score 10 Points", "Score 50 Points", "Kill Boss"]
   */
  
  func defineAchievement(name: String,
                         description: String,
                         propertyNames: [String],
                         tag: String) {
    
    // Check for duplicate achievements.
    for achievement in self.achievements {
      if achievement.name == name {
        return
      }
    }
    
    let achievement = NSEntityDescription.insertNewObjectForEntityForName("Achievement", inManagedObjectContext: context) as! Achievement
    
    // Check whether the required properties for this achievement exists.
    let matchingProperties: [AchievementProperty]? =
      properties.filter { propertyNames.contains($0.name!) }
    
    guard matchingProperties != nil else {
      Logger.Warn("There are no matching properties for the achievement.")
      return
    }
    
    achievement.properties = Set(matchingProperties!)
    achievement.name = name
    achievement.tag = tag
    achievement.desc = description
    
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  /// Gets the current value of a `AchievementProperty`.
  
  func getValue(propertyName: String) -> Int {
    return properties.filter { $0.name! == propertyName }
      .first!
      .currentValue as! Int
  }
  
  /**
   Sets the a new value for the `AchievementProperty`.
   It doesn't overwrite the value if the achievementProperty will be activated.
   */
  
  func setValue(propertyName: String, value: Int) {
    
    var value = value
    let property = properties.filter { $0.name == propertyName }.first
    
    // Update value only if we achieved a better (lesser or greater, depeding on the case)
    // value than the original one, not losing the previous achieved value.
    
    let currentPropertyValue = property?.currentValue! as! Int
    
    switch property!.activation! {
    case ">":
      value = value > currentPropertyValue ? value : currentPropertyValue
    case "<":
      value = value < currentPropertyValue ? value : currentPropertyValue
    default: return
    }
    
    property!.currentValue = value;
  }
  
  /// Set the current value for multiple `AchievementProperty`.
  
  func setValue(properties: [AchievementProperty], value: Int) {
    for property in properties {
      setValue(property.name!, value: getValue(property.name!) + value)
    }
  }
  
  /**
   Returns a list of the unlocked achievements.
   */
  
  func checkAchievements() -> [Achievement] {
    var unlockedAchievements = [Achievement]();
    
    for achievement in achievements {
      
      if achievement.isUnlocked! == false {
        var activePropertiesCount = 0
        
        // Check for active properties
        let properties = achievement.properties!
        
        for property in properties where property.isActive() {
          activePropertiesCount += 1
        }
        
        // If all properties are active, the achievement is unlocked
        if activePropertiesCount == achievement.properties!.count {
          achievement.isUnlocked = true
          unlockedAchievements.append(achievement)
        }
      }
    }
    
    return unlockedAchievements
  }
}