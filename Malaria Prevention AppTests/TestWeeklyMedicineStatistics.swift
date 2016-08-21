import XCTest
@testable import Malaria_Prevention_App

class TestWeeklyMedicineStatistics: XCTestCase {
  
  var m: MedicineManager!
  let d1 = NSDate.from(2010, month: 1, day: 4) + NSCalendar.currentCalendar().firstWeekday.day //start of the week.
  let currentPill = Medicine.Pill.mefloquine // weekly Pill.
  
  var md: Medicine!
  var currentContext: NSManagedObjectContext!
  var registriesManager: RegistriesManager!
  var stats: MedicineStats!
  
  /*
   No entries past the 5th week.
   */
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    m = MedicineManager(context: currentContext)
    
    m.registerNewMedicine(currentPill.name(),
                          interval: currentPill.interval())
    m.setCurrentPill(currentPill.name())
    
    md = m.getCurrentMedicine()!
    
    registriesManager = md.registriesManager
    stats = md.stats
    for i in 0...5{
      XCTAssertTrue(registriesManager.addRegistry(d1 + i.week, tookMedicine: true).registryAdded)
    }
  }
  
  override func tearDown() {
    super.tearDown()
    m.clearCoreData()
  }
  
  func testPillStreak() {
    XCTAssertEqual(stats.pillStreak(), 6)
    XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false).registryAdded)
    XCTAssertEqual(stats.pillStreak(), 0)
  }
  
  func testPillStreakMissingEntries() {
    // Baseline.
    XCTAssertEqual(stats.pillStreak(), 6)
    
    // 1 week gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 8.week, tookMedicine: false).registryAdded)
    XCTAssertEqual(stats.pillStreak(), 0)
    
    // 2 more week gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 10.week, tookMedicine: true).registryAdded)
    XCTAssertEqual(stats.pillStreak(), 1)
  }
  
  func testSupposedPillsMissingEntries() {
    // Baseline on the 5th week.
    XCTAssertEqual(stats.numberSupposedPills(), 6)
    
    // 1 week gap. 6th and 7th week were skipped. week none.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 8.week, tookMedicine: false).registryAdded)
    XCTAssertEqual(stats.numberSupposedPills(), 9)
    
    // 1 more week gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 10.week, tookMedicine: true).registryAdded)
    XCTAssertEqual(stats.numberSupposedPills(), 11)
  }
  
  func testSupposedPills() {
    XCTAssertEqual(stats.numberSupposedPills(), 6)
    
    XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false).registryAdded)
    XCTAssertEqual(stats.numberSupposedPills(), 7)
    
    XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: true).registryAdded)
    XCTAssertEqual(stats.numberSupposedPills(), 8)
  }
  
  
  func testPillsTaken() {
    XCTAssertEqual(stats.numberPillsTaken(), 6)
    
    XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false).registryAdded)
    XCTAssertEqual(stats.numberPillsTaken(), 6)
    
    XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: true).registryAdded)
    XCTAssertEqual(stats.numberPillsTaken(), 7)
  }
  
  func testPillsTakenMissingEntries() {
    XCTAssertEqual(stats.numberPillsTaken(), 6)
    
    // Add gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: false).registryAdded)
    XCTAssertEqual(stats.numberPillsTaken(), 6)
    
    // Add another gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 9.week, tookMedicine: true).registryAdded)
    XCTAssertEqual(stats.numberPillsTaken(), 7)
  }
}
