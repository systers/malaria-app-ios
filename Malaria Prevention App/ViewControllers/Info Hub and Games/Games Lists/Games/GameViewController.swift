import UIKit

// An abstract class that makes sure each game conforms to it.

class GameViewController: UIViewController {
  
  // MARK: Outlets.
  
  @IBOutlet weak var scoreLabel: UILabel!
  
  // MARK: Controller.
  
  var gameHandler: GameHandler? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set background image.
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    gameHandler!.startGame()
  }
  
  @IBAction func endGamePressed(sender: UIButton) {
    gameHandler!.endGame()
  }
}

extension GameViewController: GameDelegate {
  
  func setScoreLabelTextTo(newText: String) {
    scoreLabel.text = newText
  }
  
  func showStopGameAlert(text: AlertText) {
    
    let alert = UIAlertController(title: text.title,
                                  message: text.message,
                                  preferredStyle: UIAlertControllerStyle.Alert)
    
    let alertAction = UIAlertAction(title: BackButtonAlertText.title,
                                    style: UIAlertActionStyle.Default)
    {
      (action:UIAlertAction!) -> Void in
      
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    alert.addAction(alertAction)
    
    presentViewController(alert, animated: true, completion: nil)
  }
  
  func showEndGameAlert(text: AlertText) {
    
    let alert = UIAlertController(title: text.title,
                                  message: text.message,
                                  preferredStyle: UIAlertControllerStyle.Alert)
    
    let backAction = UIAlertAction(title: BackButtonAlertText.title,
                                   style: UIAlertActionStyle.Default)
    {
      (action:UIAlertAction!) -> Void in
      
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    alert.addAction(backAction)
    
    let restartGameAction = UIAlertAction(title: RestartButtonAlertText.title,
                                          style: UIAlertActionStyle.Default)
    {
      (action:UIAlertAction!) -> Void in
      self.gameHandler!.startGame()
    }
    
    alert.addAction(restartGameAction)
    
    presentViewController(alert, animated: true, completion: nil)
  }
}

// MARK: Messages.

extension GameViewController {
  
  private var BackButtonAlertText: AlertText {
    return (NSLocalizedString("Back",
      comment: "Makes the user go back to the games list."), "")
  }
  
  private var RestartButtonAlertText: AlertText {
    return (NSLocalizedString("Restart",
      comment: "Restarts the game"), "")
  }
}