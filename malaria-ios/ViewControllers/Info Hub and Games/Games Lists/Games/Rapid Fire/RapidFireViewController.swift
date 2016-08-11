import UIKit

class RapidFireViewController: GameViewController {
  
  // MARK: Outlets
  
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var countDownLabel: UILabel!
  @IBOutlet weak var questionNumberLabel: UILabel!
  @IBOutlet var answerButtons: [UIButton]!
  
  // MARK: Controller.
  
  private var rapidFireGameHandler: RFGameHandler! {
    get {
      return gameHandler as! RFGameHandler
    }
    set {
      gameHandler = newValue
    }
  }
  
  // MARK: Methods.
  
  override func viewDidLoad() {
    super.viewDidLoad()
    rapidFireGameHandler = RapidFireController()
    rapidFireGameHandler?.delegate = self
  }
  
  @IBAction func answerPressed(sender: UIButton) {
    rapidFireGameHandler.nextQuestion(sender.tag)
  }
}

extension RapidFireViewController: RFGameDelegate {
  
  func setCountdownLabelTextTo(text: String) {
    countDownLabel.text = text
  }
  
  func setAnswerButtonsTitlesBasedOn(answers: [String]) {
    for (index, answer) in answers.enumerate() {
      answerButtons[index].setTitle(answer, forState: .Normal)
    }
  }
  
  func makeCountDownLabelBlinkAtRate(rate: Double) {
    countDownLabel.blink(withRate: rate,
                         completion: { _ in self.countDownLabel?.alpha = 1.0 })
  }
  
  func showWrongAnswerAnimation() {
    let originalColor = questionLabel.textColor
    
    view.userInteractionEnabled = false
    
    let animationBlock = { () -> Void in
      self.questionLabel.textColor = UIColor.redColor()
    }
    
    let completionBlock = { (complete: Bool) in
      self.questionLabel.textColor = originalColor
      self.view.userInteractionEnabled = true
    }
    
    UIView.transitionWithView(questionLabel, duration: 0.5,
                              options: .TransitionCrossDissolve,
                              animations: animationBlock,
                              completion: completionBlock)
  }
  
  func setNextQuestionText(labelText: String,
                           numberLabelText: String) {
    questionLabel.text = labelText
    questionNumberLabel.text = numberLabelText
  }
}