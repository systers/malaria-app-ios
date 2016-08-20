import UIKit
import XCTest
@testable import Malaria_Prevention_App

class TestRFGameAchievements: XCTestCase {
  
  let am = AchievementManager.sharedInstance
  var rfam =  RapidFireAchievementManager.sharedInstance
  
  override func setUp() {
    super.setUp()
    rfam.defineAchievements()
  }
  
  override func tearDown() {
    super.tearDown()
    am.clearAchievements()
  }
  
  func testFlawlessGame() {
    var rapidFireGame = RapidFireGame()
    
    rapidFireGame.maximumScore = rapidFireGame.numberOfLevels + 1
    
    // Send a notification that doesn't fulfill the achievement.
    var dict = ["game": rapidFireGame]
    NSNotificationEvents.RFGameFinished(dict)
    
    var achievementUnlocked = am.isAchievementUnlocked(achievement: RapidFireAchievementManager.FlawlessGame)
    
    XCTAssertFalse(achievementUnlocked)
    
    rapidFireGame = RapidFireGame()
    
    rapidFireGame.maximumScore = rapidFireGame.numberOfLevels
    
    // Send a notification that fulfills the achievement.

    dict = ["game": rapidFireGame]
    NSNotificationEvents.RFGameFinished(dict)
    
    achievementUnlocked = am.isAchievementUnlocked(achievement: RapidFireAchievementManager.FlawlessGame)
    
    XCTAssertTrue(achievementUnlocked)
  }
}