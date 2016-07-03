import UIKit

class RapidFireViewController: GameViewController {
  
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet var answerButtons: [UIButton]!
  @IBOutlet weak var countDownLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var questionNumberLabel: UILabel!
  
  @IBInspectable let TimerBlinkAtSecond: Int = 3
  @IBInspectable let TimerMaxValue: Int = 5
  
  // Measured in seconds.
  let TimerTickingInterval: Double = 1
  
  var rapidFireGame: RapidFireGame!
  
  private var timer: NSTimer!
  
  private var currentLevel = 0 {
    didSet {
      // Check if we ran out of questions
      if rapidFireGame!.entries.count == currentLevel {
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
  
  private var userScore: Int = 0 {
    didSet {
      scoreLabel.text = "Score: \(userScore)"
    }
  }
  
  private var count = 5 {
    didSet {
      countDownLabel.text = count == 1 ? "\(count) second" : "\(count) seconds"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set background image
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    rapidFireGame = game as! RapidFireGame
    
    // Checks if we have any questions available to start the game
    if rapidFireGame!.entries.count == 0 {
      stopGame()
    }
    
    startGame()
  }
  
  func updateTimer() {
    if count == 0 {
      nextQuestion(false)
      return
    }
    
    if count <= TimerBlinkAtSecond {
      countDownLabel.blink()
    }
    
    count -= 1
  }
  
  func startGame() {
    currentLevel = 0
    count = TimerMaxValue
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
    let (title, message) = (GameProgressText.title, GameProgressText.message)
    
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
  
  func showWrongAnswerAnimation() {
    let originalColor = questionLabel.textColor
    
    let animationBlock = { () -> Void in
      self.questionLabel.textColor = UIColor.redColor()
    }
    
    let completionBlock = { (complete: Bool) in
      self.questionLabel.textColor = originalColor
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
  
  @IBAction func endGamePressed(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

// MARK: Messages

extension RapidFireViewController {
  typealias AlertText = (title: String, message: String)
  
  private var GameProgressText: AlertText {
    return ("Game over",
            "You scored \(userScore / 3) "
              + ( ((userScore / 3) == 1) ? "point." : "points.")
    )
  }
  
  private var NoRFEntries: AlertText {
    return ("Couldn't start game",
            "There was a problem fetching the content for this game.")
  }
}

// MARK: Label Extension

extension UILabel {
  
  func blink() {
    self.alpha = 1.0;
    UIView.animateWithDuration(0.2, // Time duration you want
      delay: 0.0,
      options: [.CurveEaseInOut, .Autoreverse],
      animations: { [weak self] in self?.alpha = 0.0 },
      completion: { [weak self] _ in self?.alpha = 1.0 })
  }
}