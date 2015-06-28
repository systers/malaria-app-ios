import Foundation
import UIKit

enum ExistingViewsControllers : String{
    case SetupScreenViewController = "SetupScreenViewController"
    case PagesManagerViewController = "PagesManagerViewController"
    case DidTakePillViewController = "DidTakePillsViewController"
    case DailyStatsTableViewController = "DailyStatsTableViewController"
    case PillsStatsViewController = "PillsStatsViewController"
    case PlanTripViewController = "PlanTripViewController"
    case InfoViewController = "InfoViewController"
    case DebugViewController = "DebugViewController"
    
    /// instanciate the view controller from the storyboard "Main"
    func instanciateViewController() -> UIViewController{
        var id = rawValue
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(id) as! UIViewController
    }
}