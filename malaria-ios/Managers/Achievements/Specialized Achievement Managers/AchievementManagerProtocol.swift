protocol SpecializedAchievementManager {
  
  func defineAchievements()
  func checkAchievements(notification: NSNotification)
  
  var tag: String { get }
}