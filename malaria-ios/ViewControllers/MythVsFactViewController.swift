import UIKit

class MythVsFactViewController: GameViewController {
  
  @IBOutlet weak var statementNumberLabel: UILabel!
  @IBOutlet weak var statementLabel: UILabel!
  
  @IBOutlet weak var yesView: UIImageView!
  @IBOutlet weak var noView: UIImageView!
  
  var statementLabelInitialFrame: CGRect!
  
  var mythVsFactGame: MythVsFactGame!
  
  let CorrectAnswerBlinkRate: Double = 1

  override var currentLevel: Int {
    didSet {
      
      // Check if we are at first level
      if currentLevel == 0 {
        setNextStametent()
        return
      }
      
      // Else, show the previous correct answer first then set the label
      let completion: (Bool) -> () = {
        _ in
        self.yesView?.alpha = CGFloat(1.0)
        self.noView?.alpha = CGFloat(1.0)
        
        self.view.userInteractionEnabled = true

        // Check if the game finished
        if self.currentLevel == self.game!.numberOfLevels {
          self.endGame()
          return
        }
        
        self.setNextStametent()
      }
      
      view.userInteractionEnabled = false
      
      if mythVsFactGame.entries[currentLevel - 1].correctAnswer {
        yesView.blink(withRate: CorrectAnswerBlinkRate, completion: completion)
      }
      else {
        noView.blink(withRate: CorrectAnswerBlinkRate, completion: completion)
      }
    }
  }
  
  func setNextStametent() {
    // Just show the statement
    statementLabel.text = mythVsFactGame?.entries[currentLevel].statement
    
    statementNumberLabel.text = "Statement \(currentLevel + 1) / \(mythVsFactGame!.entries.count)"
  }
  
  override func viewWillAppear(animated: Bool) {
    mythVsFactGame = game as! MythVsFactGame
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    statementLabelInitialFrame = statementLabel.frame
  }
  
  override func endGame() {
    super.endGame()
    
    // Send a notification that the game has finished.
    let dict = ["game" : mythVsFactGame]
    NSNotificationEvents.MVFGameFinished(dict)
  }
  
  @IBAction func pan(sender: UIPanGestureRecognizer) {
    let translation = sender.translationInView(self.view)
    
    sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x,
                                  y: sender.view!.center.y + translation.y)
    sender.setTranslation(CGPointZero, inView: self.view)
    
    switch sender.state {
      
    case .Changed:
      sender.view!.alpha = 0.5
      
    case .Ended:
      
      // Keeping currentLevel at the corespondent scope because we don't want to increase
      // the it if the user drags the laben outside of the two zones.
      
      if yesView.frame.contains(sender.view!.center) {
        
        if mythVsFactGame.entries[currentLevel].correctAnswer {
          userScore += 1
        }
        
        currentLevel += 1
      }
      
      if noView.frame.contains(sender.view!.center) {
        
        if !mythVsFactGame.entries[currentLevel].correctAnswer {
          userScore += 1
        }
        
        currentLevel += 1
      }
      
      // Refresh the statement label to its default state
      statementLabel.alpha = 1
      statementLabel.textColor = UIColor.blackColor()
      statementLabel.frame = statementLabelInitialFrame
      
    default: self.view.bringSubviewToFront(sender.view!)
    }
  }
}

class InsetLabel: UILabel {
  
  override func drawTextInRect(rect: CGRect) {
    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)))
  }
}