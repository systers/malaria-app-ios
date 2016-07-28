import UIKit
import XCTest
@testable import malaria_ios

class TestAchievementsManager: XCTestCase {
  
  let am = AchievementManager.sharedInstance

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
    
    XCTAssert(achievement!.isUnlocked == false)
    
    am.unlock(achievement: "Test achievement 2")
    
    XCTAssert(achievement!.isUnlocked == true)
  }
  
  func testGetAchievements() {
    let tag = "Test tag"
    
    Achievement.define("Test achievement", description: "Test",
                                         tag: tag)
    
    let achievements = am.getAchievements(withTag: tag)

    XCTAssert(achievements.count == 1)
  }
}