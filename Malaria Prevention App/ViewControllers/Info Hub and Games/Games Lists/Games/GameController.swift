/**
 Used to communicate from the Controller to the View.
 Refers to what methods can the View call from the Controller.
 */

protocol GameHandler: class {
  var delegate: GameDelegate? { get set }
  func startGame()
  func stopGame()
  func endGame()
}

/**
 Used to communicate from the View to the Controller.
 Refers to what methods can the Controller call in the View.
 */

protocol GameDelegate: class {
  func setScoreLabelTextTo(newText: String)
  func showStopGameAlert(text: AlertText)
  func showEndGameAlert(text: AlertText)
}

/// Abstract mediator between the ViewController (the View) and the model (Game).

class GameController<T: Game>: GameHandler {
  
  // MARK: Constants.
  
  private let NotificationObjectName = "game"
  
  // MARK: Model.
  
  var game: T!
  
  // MARK: Properties.
  
  var _delegate: GameDelegate?
  var delegate: GameDelegate? {
    get {
      return _delegate
    }
    set {
      _delegate = newValue
    }
  }
  
  var currentLevel: Int = 0
  
  // When the userScore changes, we need to modify the label in the View.
  var userScore: Int = 0 {
    didSet {
      guard let delegate = self.delegate else { fatalError("Did you forget to set the delegate?") }
      
      let localizedString = String.localizedStringWithFormat(
        NSLocalizedString("Score: %i", comment: "The user score"), userScore)
      delegate.setScoreLabelTextTo(localizedString)
    }
  }
  
  /*
   TODO: (Update this in Swift 3) Create an extension that encapsulates this methods when Swift allows overriding extension methods, because now the compiler doesn't allow it.
   */
  
  // MARK: Game Handler Methods.
  
  /// Method that starts the game if the game has any levels.
  
  func startGame() {
    if game.numberOfLevels == 0 {
      stopGame()
      return
    }
    
    currentLevel = 0
    userScore = 0
  }
  
  /// Stops a current running game.
  
  func stopGame() {
    delegate!.showStopGameAlert(NoRFEntries)
  }
  
  // Called when the game ended.
  
  func endGame() {
    
    // Send a notification that the game has finished.
    switch game {
      
    case is RapidFireGame:
      
      let dict = ["game": game as! RapidFireGame]
      NSNotificationEvents.RFGameFinished(dict)
      
    case is MythVsFactGame:
      
      let dict = ["game": game as! MythVsFactGame]
      NSNotificationEvents.MVFGameFinished(dict)
      
    default: fatalError("Switching a game that was not defined.")
    }
    
    delegate!.showEndGameAlert(GameOverText)
  }
}

// MARK: Messages.

extension GameController {
  
  // Based on the rules, we need to divide the Rapid Fire score by 3 to get the
  // achievements points earned.
  
  private var GameOverText: AlertText {
    return (
      NSLocalizedString("Game over", comment: "States that the game is over"),
      String.localizedStringWithFormat(
        NSLocalizedString("You gained %i achievement %@",
          comment: "Shows how many points the user received"), userScore,
        userScore == 1
          ? NSLocalizedString("point", comment: "")
          : NSLocalizedString("points", comment: "")
      ))
  }
  
  private var NoRFEntries: AlertText {
    return (
      NSLocalizedString("Couldn't start game", comment: "User couldn't start the game"),
      NSLocalizedString("There was a problem fetching the content for this game.", comment: ""))
  }
}