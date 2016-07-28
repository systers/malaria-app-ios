import UIKit

class AchievementsViewController: UIViewController {
  typealias AchievementObject = (sectionName: String, achievements: [Achievement])
  
  @IBOutlet weak var tableView: UITableView!
  
  // The array that will hold each section's name and its achievements.
  var allAchievements: [AchievementObject] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    tableView.estimatedRowHeight = 75.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    updateModel()
  }
  
  func updateModel() {
    allAchievements = []
    
    let achievementManager = AchievementManager.sharedInstance
    
    let gamesAchievements =
      achievementManager.getAchievements(withTag: Constants.Achievements.Tags.Games)
    
    let pillsAchievements =
      achievementManager.getAchievements(withTag: Constants.Achievements.Tags.Pills)
    
    let generalAppAchievements =
      achievementManager.getAchievements(withTag: Constants.Achievements.Tags.General)
    
    appendToModel(Constants.Achievements.Tags.Games, array: gamesAchievements)
    appendToModel(Constants.Achievements.Tags.General, array: generalAppAchievements)
    appendToModel(Constants.Achievements.Tags.Pills, array: pillsAchievements)

    tableView.reloadData()
  }
  
  func appendToModel(tag: String, array: [Achievement]) {
    if array.count > 0 {
      allAchievements.append((tag, array))
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

extension AchievementsViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    
    // This changes the header background
    view.tintColor = Constants.DefaultGreenTint
    
    // Gets the header view as a UITableViewHeaderFooterView and changes the text color
    let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
    headerView.textLabel!.textColor = UIColor.whiteColor()
  }
  
  // Solves iPad white cells bug:
  // http://stackoverflow.com/questions/24977047/tableview-cell-on-ipad-refusing-to-accept-clear-color
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.backgroundColor = UIColor.clearColor()
  }
}