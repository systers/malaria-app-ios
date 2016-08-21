import UIKit

class SetupScreenPage: UIViewController {
  
  var pageViewDelegate: SetupPageViewControllerDelegate? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set background image.
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }
  
  @IBAction func sendFeedback(sender: UIButton) {
    openUrl(NSURL(string: "mailto:\(PeaceCorpsInfo.mail)"))
  }
}
