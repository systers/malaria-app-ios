import UIKit

class AchievementsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  // The array that will hold each section's name and its achievements.
  var allAchievements: [ (sectionName: String, achievements: [Achievement]) ] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    tableView.estimatedRowHeight = 75.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    updateModel()
  }
  
  func updateModel() {
    
    let achievementManager = AchievementManager.sharedInstance
    
    let gamesAchievements = achievementManager.getAchievements(withTag: "Games")
    let pillsAchievements = achievementManager.getAchievements(withTag: "Pills")
    let generalAppAchievements = achievementManager.getAchievements(withTag: "General")

    if gamesAchievements.count > 0 {
      allAchievements.append(("Games", gamesAchievements))
    }
    
    if generalAppAchievements.count > 0 {
      allAchievements.append(("General", generalAppAchievements))
    }
    
    if pillsAchievements.count > 0 {
      allAchievements.append(("Pills", pillsAchievements))
    }
    
  }
  
}

extension AchievementsViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allAchievements[section].achievements.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return allAchievements.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return allAchievements[section].sectionName
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Achievement Cell", forIndexPath: indexPath) as! AchievementTableViewCell
    
    let section = allAchievements[indexPath.section]
    let achievement = section.achievements[indexPath.row]
    
    cell.updateCell(achievement)
    
    return cell
  }
}