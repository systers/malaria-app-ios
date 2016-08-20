import XCTest
@testable import Malaria_Prevention_App

class TestDailyMedicineStatistics: XCTestCase {
  
  var m: MedicineManager!
  let d1 = NSDate.from(2015, month: 5, day: 8)
  let currentPill = Medicine.Pill.malarone
  
  var md: Medicine!
  var currentContext: NSManagedObjectContext!
  var registriesManager: RegistriesManager!
  var stats: MedicineStats!
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    m = MedicineManager(context: currentContext)
    
    m.registerNewMedicine(currentPill.name(), interval: currentPill.interval())
    m.setCurrentPill(currentPill.name())
    
    md = m.getMedicine(currentPill.name())!
    
    registriesManager = md.registriesManager
    stats = md.stats
    
    XCTAssertTrue(registriesManager.addRegistry(d1, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 1.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 2.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 3.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 4.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 6.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 7.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 8.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 9.day, tookMedicine: true).registryAdded)
  }
  
  override func tearDown() {
    super.tearDown()
    m.clearCoreData()
  }
  
  func testProvidingRegistries() {
    let entries = registriesManager.getRegistries(mostRecentFirst: true)
    let entriesOldestFirst = registriesManager.getRegistries(mostRecentFirst: false)
    
    // Must be mostRecentFirst.
    XCTAssertEqual(10, stats.pillStreak(registries: entries))
    let customInterval = registriesManager.getRegistries(d1 - 3.day, date2: d1, mostRecentFirst: true)
    XCTAssertEqual(4, stats.pillStreak(d1 - 3.day, date2: d1, registries: customInterval))
    
    // Oldest to recent.
    XCTAssertEqual(10, stats.numberSupposedPills(registries: entriesOldestFirst))
    let customInterval2 = registriesManager.getRegistries(d1 - 1.day, date2: d1, mostRecentFirst: true)
    XCTAssertEqual(2, stats.numberSupposedPills(d1 - 1.day, date2: d1, registries: customInterval2))
    
    // Indiferent.
    XCTAssertEqual(10, stats.numberPillsTaken(registries: entries))
    XCTAssertEqual(10, stats.numberPillsTaken(registries: entriesOldestFirst))
    XCTAssertEqual(4, stats.numberPillsTaken(d1 - 3.day, date2: d1, registries: customInterval.reverse()))
    
    // Indiferent.
    XCTAssertEqual(1, stats.pillAdherence(registries: entries))
    XCTAssertEqual(1, stats.pillAdherence(registries: entriesOldestFirst))
    // Miss one: 9/10
    XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true).registryAdded)
    
    let updatedEntries = registriesManager.getRegistries(mostRecentFirst: true)
    let reverseUpdatedEntries = registriesManager.getRegistries(mostRecentFirst: false)
    
    XCTAssertEqual(0.9, stats.pillAdherence(registries: updatedEntries))
    XCTAssertEqual(0.9, stats.pillAdherence(registries: reverseUpdatedEntries))
  }
  
  func testPillStreak() {
    XCTAssertEqual(10, stats.pillStreak())
    XCTAssertEqual(6, stats.pillStreak(d1, date2: d1 - 5.day))
    
    // Miss one pill.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true).registryAdded)
    XCTAssertEqual(0, stats.pillStreak(d1 - 9.day, date2: d1 - 5.day))
    XCTAssertEqual(5, stats.pillStreak(d1, date2: d1 - 5.day))
    
    // Did not took a pill more recently.
    XCTAssertTrue(registriesManager.addRegistry(d1, tookMedicine: false, modifyEntry: true).registryAdded)
    XCTAssertEqual(0, stats.pillStreak())
  }
  
  func testPillStreakCustomArgs() {
    XCTAssertEqual(3, stats.pillStreak(d1 - 2.day))
    
    // Miss one pill.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 3.day, tookMedicine: false, modifyEntry: true).registryAdded)
    XCTAssertEqual(1, stats.pillStreak(date2: d1 - 2.day))
    XCTAssertEqual(0, stats.pillStreak(date2: d1 - 3.day))
  }
  
  func testPillStreakMissingEntries() {
    XCTAssertEqual(10, stats.pillStreak())
    
    // Add a five day gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 5.day, tookMedicine: true).registryAdded)
    XCTAssertEqual(1, stats.pillStreak())
    
    XCTAssertTrue(registriesManager.addRegistry(d1 + 6.day, tookMedicine: true).registryAdded)
    XCTAssertEqual(2, stats.pillStreak())
    
    // Add one day gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 8.day, tookMedicine: false).registryAdded)
    XCTAssertEqual(0, stats.pillStreak())
  }
  
  
  func testSupposedPills() {
    XCTAssertEqual(10, stats.numberSupposedPills())
    
    // Add one pill.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 10.day, tookMedicine: false).registryAdded)
    XCTAssertEqual(11, stats.numberSupposedPills())
    
    // Miss one pill.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 11.day, tookMedicine: false).registryAdded)
    XCTAssertEqual(12, stats.numberSupposedPills())
    
    // Miss one pill in the past.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true).registryAdded)
    XCTAssertEqual(3, stats.numberSupposedPills(d1 - 6.day, date2: d1 - 4.day))
  }
  
  func testSupposedPillsMissingEntries() {
    // Baseline.
    XCTAssertEqual(10, stats.numberSupposedPills())
    
    // Add 1 days gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 2.day, tookMedicine: false).registryAdded)
  }
  
  func testPillsTaken() {
    XCTAssertEqual(10, stats.numberPillsTaken())
    XCTAssertEqual(6, stats.numberPillsTaken(d1, date2: d1 - 5.day))
    
    // Add one pill.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 11.day, tookMedicine: true).registryAdded)
    XCTAssertEqual(11, stats.numberPillsTaken())
    
    // Miss one pill.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 10.day, tookMedicine: false).registryAdded)
    XCTAssertEqual(11, stats.numberPillsTaken())
    
    // Miss one pill in the past.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true).registryAdded)
    XCTAssertEqual(2, stats.numberPillsTaken(d1 - 6.day, date2: d1 - 4.day))
  }
  
  func testPillsTakenMissingEntries() {
    // Baseline.
    XCTAssertEqual(10, stats.numberPillsTaken())
    
    // Add 1 day gap.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 2.day, tookMedicine: true).registryAdded)
    XCTAssertEqual(11, stats.numberPillsTaken())
    
    // Check if doesn't change.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 6.day, tookMedicine: false).registryAdded)
    XCTAssertEqual(11, stats.numberPillsTaken())
  }
  
  func testAdherence() {
    XCTAssertEqual(1, stats.pillAdherence())
    
    // Add one pill.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 10.day, tookMedicine: true).registryAdded)
    XCTAssertEqual(1, stats.pillAdherence())
    
    // Miss one pill.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 11.day, tookMedicine: false).registryAdded)
    
    XCTAssertEqual(Float(stats.numberPillsTaken())/Float(stats.numberSupposedPills()), stats.pillAdherence())
    
    // Miss one pill in the past.
    XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true).registryAdded)
    
    let afterDate = d1 - 6.day
    let beforeDate = d1 - 4.day
    
    let expectedAdherence = Float(stats.numberPillsTaken(afterDate, date2: beforeDate))/Float(stats.numberSupposedPills(afterDate, date2: beforeDate))
    
    XCTAssertEqual(expectedAdherence, stats.pillAdherence(afterDate, date2: beforeDate))
  }
}