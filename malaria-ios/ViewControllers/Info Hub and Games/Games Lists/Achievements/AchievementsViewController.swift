import UIKit

class AchievementsViewController: UIViewController {
  typealias AchievementObject = (sectionName: String, achievements: [Achievement])

  private let cellIdentifier = "Achievement Cell"
  
  @IBOutlet weak var tableView: UITableView!
  
  // The array that will hold each section's name and its achievements.
  var allAchievements: [AchievementObject] = []
  
  // The parent page manager.
  var pagesManager: InfoHubPageManagerViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    tableView.estimatedRowHeight = 75.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    pagesManager.currentViewController = self
    updateModel()
  }
  
  func updateModel() {
    allAchievements = []
    
    let achievementManager = AchievementManager.sharedInstance
    
    for (tag, achievements) in achievementManager.getAchievements()
      where achievements.count > 0 {
        allAchievements.append((tag, achievements))
    }
    
    tableView.reloadData()
  }

}

// MARK: Table View Data Source.

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
    
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AchievementTableViewCell
    
    let section = allAchievements[indexPath.section]
    let achievement = section.achievements[indexPath.row]
    
    cell.updateCell(achievement)
    
    return cell
  }
}

// MARK: Table View Delegate.

extension AchievementsViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    
    // Changes the header background.
    view.tintColor = Constants.DefaultGreenTint
    
    // Gets the header view as a UITableViewHeaderFooterView and changes the text color.
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel!.textColor = UIColor.whiteColor()
  }
  
  // Solves iPad white cells bug:
  // http://stackoverflow.com/questions/24977047/tableview-cell-on-ipad-refusing-to-accept-clear-color
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.backgroundColor = UIColor.clearColor()
  }
}

// MARK: Presents Modality Delegate.

// We need to respect this protocol in order to support the Settings button.

extension AchievementsViewController: PresentsModalityDelegate {
  func onDismiss() { }
}