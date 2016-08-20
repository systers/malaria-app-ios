import UIKit
import XCTest
@testable import Malaria_Prevention_App

class TestMedicineAchievements: XCTestCase {
  
  let currentPill = Medicine.Pill.malarone
  var currentContext: NSManagedObjectContext!
  
  var m: MedicineManager!
  let am = AchievementManager.sharedInstance
  var mam: MedicineAchievementManager!
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    m = MedicineManager(context: currentContext)
    m.registerNewMedicine(currentPill.name(), interval: currentPill.interval())
    m.setCurrentPill(currentPill.name())

    mam = MedicineAchievementManager(medicine: m.getCurrentMedicine()!)
    mam.defineAchievements()
  }
  
  override func tearDown() {
    super.tearDown()
    am.clearAchievements()
    m.clearCoreData()
  }
  
  func testStayingSafeAchievement() {
    var achievementUnlocked =
      am.isAchievementUnlocked(achievement: MedicineAchievementManager.StayingSafe)
    XCTAssertFalse(achievementUnlocked)
    
    // Take medicine for today
    m.getCurrentMedicine()!.registriesManager.addRegistry(NSDate(), tookMedicine: true, modifyEntry: true)
    
    achievementUnlocked = am.isAchievementUnlocked(achievement: MedicineAchievementManager.StayingSafe)
    XCTAssertTrue(achievementUnlocked)
  }
}