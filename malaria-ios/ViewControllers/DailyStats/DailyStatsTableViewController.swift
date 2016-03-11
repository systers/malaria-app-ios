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
        NSNotificationEvents.ObserveEnteredForeground(self, selector: "refreshScreen")

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
        
        // Social Integration with Label
        let tapGesture = UITapGestureRecognizer(target: self, action: "didPressInfo:")
        cell.statValueLbl.tag = indexPath.row
        cell.statValueLbl.addGestureRecognizer(tapGesture)
        cell.statValueLbl.userInteractionEnabled = true
        cell.selectionStyle = .None
        
        return cell
    }
}

extension DailyStatsTableViewController{
    func didPressInfo(sender: UITapGestureRecognizer) {
        guard let indexOfCell = sender.view?.tag else {
            return
        }
        
        let socialItem = listStats[indexOfCell] as! SocialShareable
        
        let actionSheet = UIAlertController(title: "", message: "Share Your Stats!", preferredStyle: .ActionSheet)
        
        let facebookPostAction = UIAlertAction(title: "Facebook", style: .Default) { [unowned self] (action) -> Void in
            self.share(socialItem, toMedia: .Facebook, withMessage: "ASD")
        }
        
        let twitterTweetAction = UIAlertAction(title: "Twitter", style: .Default) { [unowned self] (action) -> Void in
            self.share(socialItem, toMedia: .Twitter, withMessage: "ASD")
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(twitterTweetAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}