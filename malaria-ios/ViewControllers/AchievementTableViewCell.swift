import UIKit

class AchievementTableViewCell: UITableViewCell {
  
  @IBOutlet weak var achievementName: UILabel!
  @IBOutlet weak var achievementDescription: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
  
  func updateCell(achievement: Achievement) {
    
    achievementName.text = achievement.name
    achievementDescription.text = achievement.desc!
    
    // Check how many properties were activated (unlocked)
    
    var activePropertiesCount = 0
    let totalPropertiesCount = achievement.properties!.count
    
    achievement.properties!
      .filter { $0.isActive() }
      .forEach { _ in activePropertiesCount += 1 }
    
    // Set the progress bar based on the previous result.
    
    let fractionalProgress = Float(activePropertiesCount) / Float(totalPropertiesCount)
    let animated = activePropertiesCount != 0
    
    progressView.setProgress(fractionalProgress, animated: animated)
  }
}