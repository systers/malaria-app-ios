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
    
    XCTAssert(!achievement!.isUnlocked)
    
    am.unlock(achievement: "Test achievement 2")
    
    XCTAssert(achievement!.isUnlocked)
  }
  
  func testGetAchievements() {
    let tag = "Test tag"
    
    Achievement.define("Test achievement", description: "Test",
                                         tag: tag)
    
    let achievements = am.getAchievements(withTag: tag)

    XCTAssert(achievements.count == 1)
  }
  
  func testGetAchievementWithUndefinedTag() {
    let achievements = am.getAchievements(withTag: "undefined")
    
    XCTAssert(achievements.count == 0)
  }
  
  func testGetAchievementsWithSameTag() {
    let tag = "Test tag"
    
    Achievement.define("Test achievement 3", description: "Test",
                       tag: tag)

    Achievement.define("Test achievement 4", description: "Test",
                       tag: tag)

    let achievements = am.getAchievements(withTag: tag)
    
    XCTAssert(achievements.count == 2)
  }
}