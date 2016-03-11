import Foundation
import UIKit

/// `DailyStatsTableViewController` presents to the user his daily stats for the current medicine
class DailyStatsTableViewController : UITableViewController{

  private var listStats: [Stat] = [
    MedicineLastTaken(),
    PillStreak(),
    Adherence()
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationEvents.ObserveAppBecomeActive(self, selector: "refreshScreen")
  }

  deinit{
    NSNotificationEvents.UnregisterAll(self)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    refreshScreen()
  }

  var pagesManager: PagesManagerViewController!
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    pagesManager.currentViewController = self
  }



  func refreshScreen() {
    Logger.Info("Refreshing DAILY")
    let cachedStats = CachedStatistics.sharedInstance
    if !cachedStats.isDailyStatsUpdated {
      cachedStats.refreshContext()
      cachedStats.setupBeforeCaching()

      cachedStats.retrieveDailyStats({ self.tableView.reloadData()})
    }else {
      tableView.reloadData()
    }
  }
}

//MARK: PresentsModalityDelegate
extension DailyStatsTableViewController : PresentsModalityDelegate{
  func OnDismiss() {
    refreshScreen()
  }
}

//MARK: Table View Controller related methods
extension DailyStatsTableViewController{
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listStats.count
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 125.0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let stat = listStats[indexPath.row]

    let cell = tableView.dequeueReusableCellWithIdentifier("statCell") as! StateCell
    cell.statLbl.text = stat.title
    cell.statIcon.image = stat.image
    cell.statValueLbl.text = stat.attributeValue

    //yes, it is really needed to remove white background color from ipad
    cell.backgroundColor = cell.backgroundColor

    return cell
  }
}