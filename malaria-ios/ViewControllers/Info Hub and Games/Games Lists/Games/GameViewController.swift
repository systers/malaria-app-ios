import UIKit

// An abstract class that makes sure each game conforms to it.
class GameViewController: UIViewController {
  
  @IBOutlet weak var scoreLabel: UILabel!

  private let NotificationObjectName = "game"
  
  var game: Game!

  var userScore: Int = 0 {
    didSet {
      scoreLabel.text = "Score: \(userScore)"
    }
  }
  
  var currentLevel: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set background image
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if game.numberOfLevels == 0 {
      stopGame()
      return
    }
    
    startGame()
  }
  
  func startGame() {
    currentLevel = 0
    userScore = 0
  }
  
  func stopGame() {
    let (title, message) = (NoRFEntries.title, NoRFEntries.message)
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let alertAction = UIAlertAction(title: "Back", style: UIAlertActionStyle.Default) {
      (action:UIAlertAction!) -> Void in
      
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    alert.addAction(alertAction)
    
    presentViewController(alert, animated: true, completion: nil)
  }
  
  func endGame() {
    let (title, message) = (GameOverText.title, GameOverText.message)
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let backAction = UIAlertAction(title: "Back", style: UIAlertActionStyle.Default) {
      (action:UIAlertAction!) -> Void in
      
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    alert.addAction(backAction)
    
    let restartGameAction = UIAlertAction(title: "Restart", style: UIAlertActionStyle.Default) {
      (action:UIAlertAction!) -> Void in
      self.startGame()
    }
    
    alert.addAction(restartGameAction)
    
    presentViewController(alert, animated: true, completion: nil)
  }
  
  @IBAction func endGamePressed(sender: UIButton) {
    endGame()
  }
}

// MARK: Messages

extension GameViewController {
  typealias AlertText = (title: String, message: String)
  
  // Based on the rules, we need to divide the Rapid Fire score by 3 to get the
  // achievements points earned.
  private var GameOverText: AlertText {
    return ("Game over",
            "You gained \(userScore) achievement "
              + ( ((userScore) == 1) ? "point." : "points.")
    )
  }
  
  private var NoRFEntries: AlertText {
    return ("Couldn't start game",
            "There was a problem fetching the content for this game.")
  }
}


// MARK: UIView Extension

extension UIView {
  
  // Make views blink at a given rate
  func blink(withRate rate: Double, completion: (Bool) -> Void) {
    self.alpha = 1.0;
    UIView.animateWithDuration(rate,
                               delay: 0.0,
                               options: [.CurveEaseInOut, .Autoreverse],
                               animations: { [weak self] in self?.alpha = 0.0 },
                               completion: completion)
  }
}