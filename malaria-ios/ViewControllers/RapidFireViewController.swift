import UIKit

class RapidFireViewController: GameViewController {
  
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet var answerButtons: [UIButton]!
  @IBOutlet weak var countDownLabel: UILabel!
  @IBOutlet weak var questionNumberLabel: UILabel!
  
  @IBInspectable let TimerBlinkAtSecond: Int = 3
  @IBInspectable let TimerMaxValue: Int = 5
  
  // Measured in seconds.
  let TimerTickingInterval: Double = 1
  
  var rapidFireGame: RapidFireGame!
  
  private var timer: NSTimer!
  
  override var currentLevel: Int {
    didSet {
      // Check if we ran out of questions
      if currentLevel >= game!.numberOfLevels {
        endGame()
        return
      }

      // Set the question
      questionLabel.text = rapidFireGame?.entries[currentLevel].question
      questionNumberLabel.text = "Question \(currentLevel + 1) / \(rapidFireGame!.entries.count)"
      
      // Set the answer buttons
      let answers = rapidFireGame?.entries[currentLevel].answers
      for (index, answer) in (answers?.enumerate())! {
        answerButtons[index].setTitle(answer, forState: .Normal)
      }
      
      // Set timer
      timer = NSTimer.scheduledTimerWithTimeInterval(TimerTickingInterval, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
  }
  
  private var count = 5 {
    didSet {
      countDownLabel.text = count == 1 ? "\(count) second" : "\(count) seconds"
    }
  }
  
  func updateTimer() {
    if count == 0 {
      nextQuestion(false)
      return
    }
    
    if count <= TimerBlinkAtSecond {
      countDownLabel.blink(withRate: Constants.RapidFireGame.RemainingSecondsBlinkRate,
                           completion: { _ in self.countDownLabel?.alpha = 1.0 })
    }
    
    count -= 1
  }
  
  override func viewWillAppear(animated: Bool) {
    
    rapidFireGame = game as! RapidFireGame
    
    super.viewWillAppear(animated)
  }
  
  override func startGame() {
    super.startGame()
    count = TimerMaxValue
  }
  
  override func endGame() {
    super.endGame()
    timer.invalidate()
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
  
  func nextQuestion(correctAnswer: Bool) {
    if correctAnswer {
      userScore += 1
    } else {
      showWrongAnswerAnimation()
    }
    
    // Reset timer
    count = 5
    timer?.invalidate()
    
    currentLevel += 1
  }
  
  @IBAction func answerPressed(sender: UIButton) {
    let correctAnswer = rapidFireGame?.entries[currentLevel].correctAnswer == sender.tag
    nextQuestion(correctAnswer)
  }

}