import UIKit
import XCTest
@testable import Malaria_Prevention_App

class TestAchievementsManager: XCTestCase {
  
  let am = AchievementManager.sharedInstance

  override func setUp() {
    super.setUp()
    am.clearAchievements()
  }
  
  override func tearDown() {
    super.tearDown()
    am.clearAchievements()
  }
    
  func testDuplicateAchievements() {
    var achievement = Achievement.define("Test achievement", description: "Test",
                                         tag: "Test tag")
    
    XCTAssertNotNil(achievement)
    
    achievement = Achievement.define("Test achievement", description: "Test",
                                         tag: "Test tag")
    
    XCTAssertNil(achievement)
  }
  
  func testUnlockingAchievements() {
    let achievement = Achievement.define("Test achievement 2", description: "Test",
                                         tag: "Test tag")
    
    XCTAssert(!achievement!.isUnlocked)
    
    am.unlock(achievement: "Test achievement 2")
    
    XCTAssert(achievement!.isUnlocked)
  }
  
  func testGetAchievements() {
    let tag = "Test tag"
    
    Achievement.define("Test achievement", description: "Test",
                                         tag: tag)
    
    am.addTag(tag)

    let achievements = am.getAchievements()

    XCTAssert(achievements.count == 1)
  }
  
}