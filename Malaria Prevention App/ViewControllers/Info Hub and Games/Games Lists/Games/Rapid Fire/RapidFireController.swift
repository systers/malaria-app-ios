protocol RFGameHandler: GameHandler {
  func nextQuestion(responseIndex: Int)
}

protocol RFGameDelegate: GameDelegate {
  
  func setCountdownLabelTextTo(text: String)
  func setAnswerButtonsTitlesBasedOn(answers: [String])
  func makeCountDownLabelBlinkAtRate(rate: Double)
  func showWrongAnswerAnimation()
  func setNextQuestionText(labelText: String,
                           numberLabelText: String)
}

/// Concrete mediator between the RFViewController (the View) and the model (RFGame).

final class RapidFireController: GameController<RapidFireGame>, RFGameHandler {
  
  // MARK: Constants.
  
  let TimerBlinkAtSecond: Int = 3
  let TimerMaxValue: Int = 5
  
  private let TimerTickingSecondsInterval: Double = 1
  private let RemainingSecondsBlinkRate = 0.2
  
  // MARK: Properties.
  
  private var rapidFireDelegate: RFGameDelegate? {
    
    guard let delegate = delegate as? RFGameDelegate else {
      fatalError("Did you forget to set the delegate?")
    }
    
    return delegate
  }
  
  private var timer: NSTimer!
  
  private var count = 5 {
    didSet {
      
      let localizedString = String.localizedStringWithFormat(
        NSLocalizedString("%i %@", comment: "Number of seconds"), count,
        count == 1
          ? NSLocalizedString("second", comment: "")
          : NSLocalizedString("seconds", comment: ""))
      let newText = localizedString
      rapidFireDelegate!.setCountdownLabelTextTo(newText)
    }
  }
  
  override var currentLevel: Int {
    didSet {
      // Check if we ran out of questions.
      if currentLevel >= game!.numberOfLevels {
        endGame()
        return
      }
      
      let labelText = game?.entries[currentLevel].question
      let localizedString = String.localizedStringWithFormat(
        NSLocalizedString("Question %i / %i", comment: "The question number"),
        currentLevel + 1, game!.entries.count)
      let numberLabelText = localizedString
      
      rapidFireDelegate!.setNextQuestionText(labelText!,
                                             numberLabelText: numberLabelText)
      
      let answers = game?.entries[currentLevel].answers
      rapidFireDelegate!.setAnswerButtonsTitlesBasedOn(answers!)
      
      // Set timer
      resetTimer()
      timer = NSTimer.scheduledTimerWithTimeInterval(TimerTickingSecondsInterval,
                                                     target: self,
                                                     selector:#selector(updateTimer),
                                                     userInfo: nil,
                                                     repeats: true)
    }
  }
  
  // MARK: Methods.
  
  override func startGame() {
    game = RapidFireGame()
    
    super.startGame()
    
    count = TimerMaxValue
  }
  
  override func stopGame() {
    timer.invalidate()
    
    super.stopGame()
  }
  
  override func endGame() {
    
    // Save the user's final score
    game.maximumScore = userScore
    
    timer.invalidate()
    
    super.endGame()
  }
  
  /*
   @objc is required due to "Argument of #selector referts to a method that is
   not exposed to Objective-C.
   */
  
  /// The timer's on tick method.
  
  @objc func updateTimer() {
    
    if count == 0 {
      currentLevel += 1
      return
    }
    
    if count <= TimerBlinkAtSecond {
      rapidFireDelegate!.makeCountDownLabelBlinkAtRate(RemainingSecondsBlinkRate)
    }
    
    count -= 1
  }
  
  func resetTimer() {
    count = TimerMaxValue
    timer?.invalidate()
  }
  
  /**
   Check if user's answer is correct and either increments his score or presents
   a "Wrong answer" animation.
   */
  
  func nextQuestion(responseIndex: Int) {
    
    let correctAnswer =
      game?.entries[currentLevel].correctAnswer == responseIndex
    
    if correctAnswer {
      userScore += 1
    } else {
      rapidFireDelegate!.showWrongAnswerAnimation()
    }
    
    currentLevel += 1
  }
}