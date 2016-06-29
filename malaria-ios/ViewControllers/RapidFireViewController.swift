import UIKit

class RapidFireViewController: UIViewController {
  
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet var answerButtons: [UIButton]!
  @IBOutlet weak var countDownLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  var rapidFireGame: RapidFireGame?
  
  private var timer: NSTimer?

  private var currentLevel = 0 {
    didSet {
      // Check if we ran out of questions
      if rapidFireGame!.entries.count == currentLevel {
        saveProgress()
        return
      }
      
      // Set the question
      questionLabel.text = rapidFireGame?.entries[currentLevel].question
      
      // Set the answer buttons
      let answers = rapidFireGame?.entries[currentLevel].answers
      for (index, answer) in (answers?.enumerate())! {
        answerButtons[index].setTitle(answer, forState: .Normal)
      }
      
      // Set timer
      timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
  }
  
  private var userScore = 0 {
    didSet {
      scoreLabel.text = "Score: \(userScore)"
    }
  }
  
  private var count = 5 {
    didSet {
      countDownLabel.text = "Time: \(count):00"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set background image
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    // Start game
    currentLevel = 0
    count = 5
  }
  
  func updateTimer() {
    count == 1 ? nextQuestion(false) : (count -= 1)
  }
  
  func saveProgress() {
    let (title, message) = (GameProgressText.title, GameProgressText.message)

    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let alertAction = UIAlertAction(title: "Back", style: UIAlertActionStyle.Default) {
      (action:UIAlertAction!) -> Void in
      self.navigationController?.popViewControllerAnimated(true)
    }
    
    alert.addAction(alertAction)
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func showWrongAnswerAnimation() {
    let defaultColor = questionLabel.textColor
    
    UIView.transitionWithView(questionLabel, duration: 0.1, options: .TransitionCrossDissolve, animations: { () -> Void in
      self.questionLabel.textColor = UIColor.redColor()
    }) { (complete: Bool) in
      self.questionLabel.textColor = defaultColor
    }
  }
  
  func nextQuestion(correctAnswer: Bool) {
    correctAnswer ? (userScore += 1) : showWrongAnswerAnimation()
    
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

// MARK: Messages

extension RapidFireViewController {
  typealias AlertText = (title: String, message: String)
  
  // Set reminder
  private var GameProgressText: AlertText {
    get {
      return ("Game over", "Each 3 points mean one achievement point. You scored \(userScore / 3) points.")
    }
  }
}