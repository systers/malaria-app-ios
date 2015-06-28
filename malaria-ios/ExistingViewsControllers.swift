import Foundation
import UIKit

enum ExistingViewsControllers : String{
    //setup screen when the application launches for the first time
    case SetupScreenViewController = "SetupScreenViewController"
    
    //main manager of paged view controller
    case PagesManagerViewController = "PagesManagerViewController"
    
    //first button
    case DidTakePillViewController = "DidTakePillsViewController"
    case DailyStatsTableViewController = "DailyStatsTableViewController"
    case PillsStatsViewController = "PillsStatsViewController"

    //second button
    case PlanTripViewController = "PlanTripViewController"
    
    //third button
    case InfoViewController = "InfoViewController"
    
    case DebugViewController = "DebugViewController"
    
    
    func instanciateViewController() -> UIViewController{
        var id = rawValue
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(id) as! UIViewController
    }
}