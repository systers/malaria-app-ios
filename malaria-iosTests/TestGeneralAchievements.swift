import UIKit
import XCTest
@testable import malaria_ios

class TestGeneralAchievements: XCTestCase {
  
  let am = AchievementManager.sharedInstance
  var tm: TripsManager!
  var gam =  GeneralAchievementsManager.sharedInstance
  
  var currentContext: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    gam.defineAchievements()
    
    //refresh context
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    tm = TripsManager(context: currentContext)
  }
  
  override func tearDown() {
    super.tearDown()
    am.clearAchievements()
  }
  
  func testFirstTrip() {
    var achievementUnlocked = am.isAchievementUnlocked(achievement: Constants.Achievements.General.PlanFirstTrip)
    
    XCTAssertFalse(achievementUnlocked)

    tm.createTrip("dasda", medicine: "", departure: NSDate(), arrival: NSDate().dateByAddingTimeInterval(30000), timeReminder: NSDate().dateByAddingTimeInterval(2000))
    
    NSNotificationEvents.TripPlanned()

    print(tm.getTrip() != nil ? "cioc" : "boc")
    
    achievementUnlocked = am.isAchievementUnlocked(achievement: Constants.Achievements.General.PlanFirstTrip)

    XCTAssert(achievementUnlocked)
  }
}