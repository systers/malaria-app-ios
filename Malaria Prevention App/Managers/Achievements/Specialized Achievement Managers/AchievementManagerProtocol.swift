/**
 Defines how a achievement manager, that seek to implement achievements for a
 respective module (specialized), needs to look.
*/

protocol SpecializedAchievementManager {
  func defineAchievements()
  func checkAchievements(notification: NSNotification)  
}