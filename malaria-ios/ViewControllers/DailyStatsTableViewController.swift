import Foundation
import UIKit

class DailyStatsTableViewController : UITableViewController{

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 125.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        if row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("medicineLastTakenCell") as! UITableViewCell
            return cell
        }else if row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("dosesCell") as! UITableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("adherenceCell") as! UITableViewCell
        return cell
    }
}