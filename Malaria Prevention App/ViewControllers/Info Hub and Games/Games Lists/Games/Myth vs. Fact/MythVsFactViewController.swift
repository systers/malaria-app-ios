import UIKit

class MythVsFactViewController: GameViewController {
  
  // MARK: Constants
  
  @IBInspectable let CorrectAnswerBlinkRate: Double = 1
  
  // MARK: Outlets.
  
  @IBOutlet weak var statementNumberLabel: UILabel!
  @IBOutlet weak var statementLabel: UILabel!
  @IBOutlet weak var yesView: UIImageView!
  @IBOutlet weak var noView: UIImageView!
  
  // MARK: Controller.
  
  private var mythVsFactGameHandler: MVFGameHandler! {
    get {
      return gameHandler as! MVFGameHandler
    }
    set {
      gameHandler = newValue
    }
  }
  
  // MARK: Properties.
  
  var statementLabelInitialFrame: CGRect!
  
  // MARK: Methods.
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mythVsFactGameHandler = MythVsFactController()
    mythVsFactGameHandler?.delegate = self
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
        mythVsFactGameHandler.checkAnswer(true)
      }
      
      if noView.frame.contains(sender.view!.center) {
        mythVsFactGameHandler.checkAnswer(false)
      }
      
      // Refresh the statement label to its default state.
      statementLabel.alpha = 1
      statementLabel.textColor = UIColor.blackColor()
      statementLabel.frame = statementLabelInitialFrame
      
    default: self.view.bringSubviewToFront(sender.view!)
    }
  }
}

extension MythVsFactViewController: MVFGameDelegate {
  
  func questionDidChangeWith(correctAnswer answer: Bool) {
    
    self.view.userInteractionEnabled = false
    
    // Show the previous correct answer first then set the label.
    let completion: (Bool) -> () = {
      _ in
      self.yesView?.alpha = CGFloat(1.0)
      self.noView?.alpha = CGFloat(1.0)
      
      self.view.userInteractionEnabled = true
      
      self.mythVsFactGameHandler.setNextStametent()
    }
    
    let targetView = answer ? yesView : noView
    targetView.blink(withRate: CorrectAnswerBlinkRate, completion: completion)
  }
  
  func setNextStatementText(labelText: String,
                            numberLabelText: String) {
    
    statementLabel.text = labelText
    statementNumberLabel.text = numberLabelText
  }
}