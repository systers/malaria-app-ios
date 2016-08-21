import UIKit
import XCTest
@testable import Malaria_Prevention_App

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
    var achievementUnlocked = am.isAchievementUnlocked(achievement: GeneralAchievementsManager.PlanFirstTrip)
    
    XCTAssertFalse(achievementUnlocked)

    let departure = NSDate()
    let arrival = NSDate() + 30.day
    let reminder = arrival - 1.day
    
    tm.createTrip("dasda", medicine: "",
                  departure: departure,
                  arrival: arrival,
                  timeReminder: reminder)
    
    achievementUnlocked = am.isAchievementUnlocked(achievement: GeneralAchievementsManager.PlanFirstTrip)

    XCTAssert(achievementUnlocked)
  }
}