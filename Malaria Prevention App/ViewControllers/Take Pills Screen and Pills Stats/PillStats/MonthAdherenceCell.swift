import Foundation
import UIKit
import HorizontalProgressView

/// `AdherenceHorizontalBarCell` shows a graph bar for the adhrence for a month.

class AdherenceHorizontalBarCell: UITableViewCell {
  
    @IBInspectable var LowAdherenceColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable var HighAdherenceColor: UIColor = UIColor(red: 0.374, green: 0.609, blue: 0.574, alpha: 1.0)
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var horizontalBar: HorizontalGraphBar!
    @IBOutlet weak var adherenceValue: UILabel!
    func configureCell(date: NSDate, adhrenceValue: Float) -> AdherenceHorizontalBarCell{
        horizontalBar.progressColor = adhrenceValue < 50 ? LowAdherenceColor : HighAdherenceColor
        horizontalBar.progressValue = adhrenceValue
        
        // Yes, it is really needed to remove white background color from ipad.
        // https://stackoverflow.com/questions/27551291/uitableview-backgroundcolor-always-white-on-ipad
        self.backgroundColor = self.backgroundColor
        
        month.text = (date.formatWith("MMM") as NSString).substringToIndex(3).capitalizedString
        adherenceValue.text = "\(Int(adhrenceValue))%"
        
        return self
    }
}