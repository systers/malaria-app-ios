protocol MVFGameHandler: GameHandler {
  func checkAnswer(answer: Bool)
  func setNextStametent()
}

protocol MVFGameDelegate: GameDelegate {
  func questionDidChangeWith(correctAnswer answer: Bool)
  func setNextStatementText(labelText: String,
                            numberLabelText: String)
}

/// Concrete mediator between the MVFViewController (the View) and the model (MVFGame).

final class MythVsFactController: GameController<MythVsFactGame>, MVFGameHandler {
  
  // MARK: Properties.
  
  private var mythVsFactDelegate: MVFGameDelegate? {
    
    guard let delegate = delegate as? MVFGameDelegate else {
      fatalError("Did you forget to set the delegate?")
    }
    
    return delegate
  }
  
  override var currentLevel: Int {
    didSet {
      // Check if we are at first level.
      if currentLevel == 0 {
        setNextStametent()
        return
      }
      
      if game.entries[currentLevel - 1].correctAnswer {
        mythVsFactDelegate?.questionDidChangeWith(correctAnswer: true)
        return
      }
      
      mythVsFactDelegate?.questionDidChangeWith(correctAnswer: false)
    }
  }
  
  override func startGame() {
    game = MythVsFactGame()
    super.startGame()
  }
  
  /// Check whether the answer was correct, incrementing the user's score.
  
  func checkAnswer(answer: Bool) {
    if game.entries[currentLevel].correctAnswer == answer {
      userScore += 1
    }
    
    currentLevel += 1
  }
  
  /// Sets the next MVF statement on the screen.
  /// If there are no more statements, it ends the game.
  
  func setNextStametent() {
    // Check if the game finished.
    if self.currentLevel == self.game!.numberOfLevels {
      self.endGame()
      return
    }
    
    let labelText = game?.entries[currentLevel].statement
    let localizedString = String.localizedStringWithFormat(
      NSLocalizedString("Statement %i / %i", comment: "The statement number."),
      currentLevel + 1, game!.entries.count)
    let numberLabelText = localizedString
    
    mythVsFactDelegate?.setNextStatementText(labelText!,
                                             numberLabelText: numberLabelText)
  }
}

// FIXME: (Probably in newer version of Xcode) Couldn't create an extension with those two functions due to Xcode triggering protocol conformance errors, which are not.

//extension MythVsFactController: MVFGameHandler {
//}