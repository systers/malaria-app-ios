import Foundation
import UIKit

/// DailyStatCell, is generic
public class StateCell: UITableViewCell{
    @IBOutlet weak var statIcon: UIImageView!
    @IBOutlet weak var statLbl: UILabel!
    @IBOutlet weak var statValueLbl: UILabel!
}

/// Protocol to be followed to extend the stats shown on the view controller
public protocol Stat{
    var title : String { get }
    var image : UIImage { get }
    var attributeValue : String { get }
}

/// Adherence stats
class Adherence: Stat{
    var title : String { return "Adherence to medicine" }
    var image : UIImage { return UIImage(named: "Adherence")! }
    var attributeValue : String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.multiplier = 1
        
        return numberFormatter.stringFromNumber(CachedStatistics.sharedInstance.todaysAdherence)!
    }
}

/// Pill Streakstats
class PillStreak : Stat{
    var title : String { return "Doses in a Row" }
    var image : UIImage { return UIImage(named: "DosesInRow")! }
    var attributeValue : String { return "\(CachedStatistics.sharedInstance.todaysPillStreak)"}
}

/// When the user last taken his medicine stats
class MedicineLastTaken : Stat{
    var title : String { return "Medicine Last Take" }
    var image : UIImage { return UIImage(named: "MedicineLastTaken")! }
    var attributeValue : String {
        if let last = CachedStatistics.sharedInstance.lastMedicine {
            return last.formatWith("M/d")
        }
        return  "-/-"
    }
}