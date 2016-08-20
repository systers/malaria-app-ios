import Foundation
import UIKit

/// Presents game rules.

class GameRulesViewController : UIViewController {
  
  @IBOutlet weak var gameTitleLabel: UILabel!
  @IBOutlet weak var gameDescriptionLabel: UILabel!
  
  // Provided by the `GamesListViewController`.
  
  var gameInfo: GameInfo!
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    segue.destinationViewController as! GameViewController
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    gameTitleLabel.text = self.gameInfo.name
    gameDescriptionLabel.text = self.gameInfo.rules
  }
  
  @IBAction func cancelBtnHandler(sender: AnyObject) {
    view.endEditing(true)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  /*
   Segues must have the identifier following the naming rule: "Show " + game.name
   in order for a game to start.
   */
  
  @IBAction func startGameBtnHandler(sender: AnyObject) {
    performSegueWithIdentifier("Show " + gameInfo.name, sender: self)
  }
}