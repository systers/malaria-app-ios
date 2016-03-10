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

    // experimental code
    //    // Using this in order to hide the widget on the app's first run
    //    // Letting the user select his medicine first
    //    if !NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.boolForKey(Constants.Widget.FirstRunFlag) {
    //      widgetController.setHasContent(false, forWidgetWithBundleIdentifier: Constants.Widget.BundleID)
    //
    //      NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.setBool(true, forKey: Constants.Widget.FirstRunFlag)
    //    }

    currentDate = NSDate()
    dayLabel.text = currentDate.formatWith(MinorDateTextFormat)
    dateLabel.text = currentDate.formatWith(FullDateTextFormat)
  }

  // Solves unnecesary widget bottom margin problem
  func widgetMarginInsetsForProposedMarginInsets(var defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    defaultMarginInsets.bottom = 10.0;
    return defaultMarginInsets;
  }

  @IBAction func yesPressed(sender: UIButton) {
    // Save entry in user defaults and let it be added to the app when it becomes active
    NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.setObject(true, forKey: Constants.Widget.DidTakePillForToday)

    // Dimiss widget
    widgetController.setHasContent(false, forWidgetWithBundleIdentifier: Constants.Widget.BundleID)
  }
}