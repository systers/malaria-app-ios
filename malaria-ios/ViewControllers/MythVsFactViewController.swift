import UIKit

class MythVsFactViewController: GameViewController {
  
  @IBOutlet weak var statementNumberLabel: UILabel!
  @IBOutlet weak var statementLabel: UILabel!
  
  @IBOutlet weak var yesView: UIImageView!
  @IBOutlet weak var noView: UIImageView!
  
  var MVFGame: MythVsFactGame!
  
  var statementLabelInitialFrame: CGRect!
  
  override var currentLevel: Int {
    didSet {
      
      // Check if we ran out of questions
      if currentLevel >= MVFGame!.entries.count {
        endGame()
        return
      }
      
      // Set the statement
      statementLabel.text = MVFGame?.entries[currentLevel].statement
      statementNumberLabel.text = "Statement \(currentLevel + 1) / \(MVFGame!.entries.count)"
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    
    MVFGame = game as! MythVsFactGame
    
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    statementLabelInitialFrame = statementLabel.frame
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
      
      if yesView.frame.contains(sender.view!.center) {
        
        if MVFGame.entries[currentLevel].correctAnswer {
          userScore += 1
        }
        
        currentLevel += 1
      }
      
      if noView.frame.contains(sender.view!.center) {
        
        if !MVFGame.entries[currentLevel].correctAnswer {
          userScore += 1
        }
        
        currentLevel += 1
      }
      
      // Refresh the statement label to its default state
      statementLabel.alpha = 1
      statementLabel.frame = statementLabelInitialFrame
      
    default: self.view.bringSubviewToFront(sender.view!)
    }
  }
}