import XCTest
@testable import Malaria_Prevention_App

class TestTimedInsertions: XCTestCase {
  var m: MedicineManager!
  
  let d1 = NSDate.from(2015, month: 6, day: 6) + NSCalendar.currentCalendar().firstWeekday.day // start of the week
  let weeklyPill = Medicine.Pill.mefloquine
  let dailyPill = Medicine.Pill.malarone
  
  var daily: Medicine!
  var weekly: Medicine!
  
  var dailyRegistriesManager: RegistriesManager!
  var weeklyRegistriesManager: RegistriesManager!
  
  var currentContext: NSManagedObjectContext!
  
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    m = MedicineManager(context: currentContext)
    
    m.registerNewMedicine(weeklyPill.name(), interval: weeklyPill.interval())
    m.registerNewMedicine(dailyPill.name(), interval: dailyPill.interval())
    
    daily = m.getMedicine(dailyPill.name())!
    weekly = m.getMedicine(weeklyPill.name())!
    
    dailyRegistriesManager = daily.registriesManager
    weeklyRegistriesManager = weekly.registriesManager
  }
  
  override func tearDown() {
    super.tearDown()
    m.clearCoreData()
  }
  
  func testDailyInsert() {
    
    XCTAssertTrue(dailyRegistriesManager.addRegistry(d1, tookMedicine: false).registryAdded)
    // Modify entry with same value, should return false.
    XCTAssertFalse(dailyRegistriesManager.addRegistry(d1, tookMedicine: false).registryAdded)
    
    // Modify entry with different value.
    XCTAssertFalse(dailyRegistriesManager.addRegistry(d1, tookMedicine: true).registryAdded)
    
    XCTAssertEqual(1, dailyRegistriesManager.getRegistries().count)
    
    
    XCTAssertTrue(dailyRegistriesManager.addRegistry(d1 - 1.day, tookMedicine: false).registryAdded)
    XCTAssertTrue(dailyRegistriesManager.addRegistry(d1 + 1.day, tookMedicine: false).registryAdded)
    
    XCTAssertEqual(3, dailyRegistriesManager.getRegistries().count)
    
  }
  
  func testWeeklyInsert() {
    XCTAssertTrue(weeklyRegistriesManager.addRegistry(d1, tookMedicine: false).registryAdded)
    XCTAssertTrue(weeklyRegistriesManager.addRegistry(d1 + 1.day, tookMedicine: true).registryAdded)
    
    XCTAssertFalse(weeklyRegistriesManager.addRegistry(d1 + 2.day, tookMedicine: true).registryAdded)
    XCTAssertFalse(weeklyRegistriesManager.addRegistry(d1 + 3.day, tookMedicine: true).registryAdded)
    XCTAssertFalse(weeklyRegistriesManager.addRegistry(d1 + 4.day, tookMedicine: true).registryAdded)
    XCTAssertFalse(weeklyRegistriesManager.addRegistry(d1 + 5.day, tookMedicine: true).registryAdded)
    XCTAssertFalse(weeklyRegistriesManager.addRegistry(d1 + 6.day, tookMedicine: true).registryAdded)
    
    XCTAssertEqual(2, weeklyRegistriesManager.getRegistries().count)
    XCTAssertTrue(weeklyRegistriesManager.addRegistry(d1 + 1.day + 1.week, tookMedicine: true).registryAdded)
    XCTAssertEqual(3, weeklyRegistriesManager.getRegistries().count)
  }
  
  func testDailyModifyPastEntry() {
    XCTAssertTrue(weeklyRegistriesManager.addRegistry(d1, tookMedicine: false).registryAdded)
    XCTAssertTrue(weeklyRegistriesManager.addRegistry(d1, tookMedicine: true, modifyEntry: true).registryAdded)
    XCTAssertEqual(1, weeklyRegistriesManager.getRegistries().count)
    XCTAssertTrue(weeklyRegistriesManager.getRegistries()[0].tookMedicine)
  }
  
  func testDifferentTimes() {
    XCTAssertTrue(dailyRegistriesManager.addRegistry(d1, tookMedicine: false).registryAdded)
    let b = d1 + 1.minute
    XCTAssertEqual(1, dailyRegistriesManager.getRegistries(b, date2: b).count)
  }
}