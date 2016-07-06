import Foundation
import UIKit

/// Presents game rules.
class GameRulesViewController : UIViewController {
  
  @IBOutlet weak var gameTitleLabel: UILabel!
  @IBOutlet weak var gameDescriptionLabel: UILabel!
  
  // Provided by previous viewController
  var game: Game!
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    print(segue.destinationViewController)
    let gameVC = segue.destinationViewController as! GameViewController
    gameVC.game = game
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    gameTitleLabel.text = self.game.name
    gameDescriptionLabel.text = self.game.rules
  }
  
  @IBAction func cancelBtnHandler(sender: AnyObject) {
    view.endEditing(true)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // Segues must have the identifier following the naming rule: "Show " + game.name
  // in order for a game to start
  @IBAction func startGameBtnHandler(sender: AnyObject) {
   performSegueWithIdentifier("Show " + game.name, sender: self)
  }
  
}