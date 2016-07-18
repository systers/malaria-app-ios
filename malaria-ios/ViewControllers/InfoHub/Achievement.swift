import Foundation
import CoreData

/// A general feat that a user can unlock using the application thoroughly.

class Achievement: NSManagedObject {

  /// Represents whether the achievement was unlocked or not.
  
  @NSManaged var isUnlocked: NSNumber?
  
  /// The title of the achievement as shown to the user.

  @NSManaged var name: String?
  
  /// A tag that will permit identifying multiple achievements by it.

  @NSManaged var tag: String?
  
  /// A short text that will describe what to do in order to unlock the achievement.

  @NSManaged var desc: String?
  
  /// The achievement's conditions that need to be activated in order for it to unlock.

  @NSManaged var properties: Set<AchievementProperty>?
  
}
