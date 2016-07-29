import UIKit

class AchievementTableViewCell: UITableViewCell {
  
  @IBOutlet weak var achievementName: UILabel!
  @IBOutlet weak var achievementDescription: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
  
  private let MaximumProgress: Float = 1.0
  
  func updateCell(achievement: Achievement) {
    
    achievementName.text = achievement.name
    achievementDescription.text = achievement.desc
    
    // Check if achievement is unlocked.
    if achievement.isUnlocked == true {
      progressView.setProgress(MaximumProgress, animated: true)
      progressLabel.text = "Completed"
      return
    }
  }
}