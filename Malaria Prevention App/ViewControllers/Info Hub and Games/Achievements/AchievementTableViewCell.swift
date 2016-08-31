import UIKit

class AchievementTableViewCell: UITableViewCell {
  
  @IBOutlet weak var achievementName: UILabel!
  @IBOutlet weak var achievementDescription: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
  
  private let MaximumProgress: Float = 1.0
  private let finishedAchievementTitle =
    NSLocalizedString("Completed",
                      comment: "Shows that an achievement was unlocked.")
  
  func updateCell(achievement: Achievement) {
    
    achievementName.text = achievement.name
    achievementDescription.text = achievement.desc
    
    // Check if achievement is unlocked.
    if achievement.isUnlocked {
      progressView.setProgress(MaximumProgress, animated: false)
      progressLabel.text = finishedAchievementTitle
    }
  }
}