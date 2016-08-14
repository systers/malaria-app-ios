import UIKit

class SetupScreenMalariaPage: SetupScreenPage {
  
  @IBAction func startPressed(sender: UIButton) {
    pageViewDelegate!.changePage()
  }
}