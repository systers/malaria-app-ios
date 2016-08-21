import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var noButton: UIButton!
  @IBOutlet weak var yesButton: UIButton!
  
  private var currentDate: NSDate = NSDate()
  @IBInspectable private let FullDateTextFormat: String = "M/d/yyyy"
  @IBInspectable private let MinorDateTextFormat: String = "EEEE"
  
  let widgetController: NCWidgetController = NCWidgetController.widgetController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    currentDate = NSDate()
    dayLabel.text = currentDate.formatWith(MinorDateTextFormat)
    dateLabel.text = currentDate.formatWith(FullDateTextFormat)
  }
  
  // Solves widget bottom margin problem.
  
  func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    var defaultMarginInsets = defaultMarginInsets
    defaultMarginInsets.bottom = 10.0;
    return defaultMarginInsets;
  }
  
  @IBAction func yesPressed(sender: UIButton) {
    
    // Save entry in user defaults and let it be added to the app when it becomes active.
    NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.setObject(true, forKey: Constants.Widget.didTakePillForToday)
    
    // Dimiss widget.
    widgetController.setHasContent(false, forWidgetWithBundleIdentifier: Constants.Widget.BundleID)
  }
}