import XCTest
@testable import Malaria_Prevention_App

class TestMedicineRegistries: XCTestCase {
  
  let d1 = NSDate.from(2015, month: 6, day: 13) //Saturday intentionally.
  let currentPill = Medicine.Pill.malarone
  
  var currentContext: NSManagedObjectContext!
  var m: MedicineManager!
  var md: Medicine!
  var registriesManager: RegistriesManager!
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    m = MedicineManager(context: currentContext)
    
    m.registerNewMedicine(currentPill.name(),
                          interval: currentPill.interval())
    m.setCurrentPill(currentPill.name())
    
    md = m.getCurrentMedicine()!
    md.notificationManager.scheduleNotification(d1)
    registriesManager = md.registriesManager
    
    XCTAssertTrue(registriesManager.addRegistry(d1, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 1.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 2.day, tookMedicine: false).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 3.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 4.day, tookMedicine: false).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 6.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 7.day, tookMedicine: false).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 8.day, tookMedicine: true).registryAdded)
    XCTAssertTrue(registriesManager.addRegistry(d1 - 9.day, tookMedicine: false).registryAdded)
  }
  
  override func tearDown() {
    super.tearDown()
    m.clearCoreData()
  }
  
  
  func testDeleteEntry() {
    registriesManager.removeEntry(d1 - 3.day)
    XCTAssertNil(registriesManager.findRegistry(d1 - 3.day))
    
    registriesManager.removeEntry(d1)
    XCTAssertEqual(registriesManager.mostRecentEntry()!.date, d1 - 1.day)
  }
  
  
  func testFindEntriesInBetween() {
    let entries = registriesManager.getRegistries(d1 - 5.day, date2: d1 - 3.day)
    
    if entries.count != 3 {
      XCTFail("Incorrect number of elements \(entries.count)")
      return
    }
    
    let r1 = entries[0]
    XCTAssertEqual(r1.date, d1 - 3.day)
    XCTAssertEqual(r1.tookMedicine, true)
    
    let r2 = entries[1]
    XCTAssertEqual(r2.date, d1 - 4.day)
    XCTAssertEqual(r2.tookMedicine, false)
    
    let r3 = entries[2]
    XCTAssertEqual(r3.date, d1 - 5.day)
    XCTAssertEqual(r3.tookMedicine, true)
    
    
    // Flip the dates, should reproduce the same results.
    let entriesFlipped = registriesManager.getRegistries(d1 - 3.day, date2: d1 - 5.day)
    
    if entriesFlipped.count == 0 {
      XCTFail("No element found")
      return
    }
    
    let r1f = entriesFlipped[0]
    XCTAssertEqual(r1f.date, d1 - 3.day)
    XCTAssertEqual(r1f.tookMedicine, true)
    
    let r2f = entriesFlipped[1]
    XCTAssertEqual(r2f.date, d1 - 4.day)
    XCTAssertEqual(r2f.tookMedicine, false)
    
    let r3f = entriesFlipped[2]
    XCTAssertEqual(r3f.date, d1 - 5.day)
    XCTAssertEqual(r3f.tookMedicine, true)
    
    
    // Check interval without entries.
    XCTAssertEqual(0, registriesManager.getRegistries(d1 - 30.day,  date2: d1 - 25.day).count)
    
    // Check interval big enough to fit every entry.
    let entries2 = registriesManager.getRegistries(d1 - 50.day, date2: d1 + 50.day)
    XCTAssertEqual(registriesManager.getRegistries().count, entries2.count)
    
    // Single registry.
    let entries3 = registriesManager.getRegistries(d1 - 4.day, date2: d1 - 4.day)
    XCTAssertEqual(1, entries3.count)
  }
  
  func testFindEntry() {
    // Find existing entry.
    let r = registriesManager.findRegistry(d1 - 4.day)!
    XCTAssertEqual(r.date, d1 - 4.day)
    XCTAssertEqual(r.tookMedicine, false)
    
    // Finding inexistent entry.
    XCTAssertEqual(true, registriesManager.findRegistry(d1 - 30.day) == nil)
  }
  
  func testAlreadyRegisteredWeeklyPill() {
    let weeklyPill = Medicine.Pill.mefloquine
    m.registerNewMedicine(weeklyPill.name(), interval: weeklyPill.interval())
    
    let weekly = m.getMedicine(weeklyPill.name())!
    
    let weeklyRegistriesManager = weekly.registriesManager
    
    // Saturday = 0, Sunday = 1 etc
    let dStartWeek = d1 + NSCalendar.currentCalendar().firstWeekday.day
    
    XCTAssertTrue(weeklyRegistriesManager.addRegistry(dStartWeek, tookMedicine: true).registryAdded)
    
    XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek - 1.day) == nil)
    XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 1.day) != nil)
    XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 2.day) != nil)
    XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 3.day) != nil)
    XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 4.day) != nil)
    XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 5.day) != nil)
    XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 6.day) != nil)
    XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 7.day) == nil)
  }
  
  func testAlreadyRegisteredDailyPill() {
    XCTAssertTrue(registriesManager.tookMedicine(d1) != nil)
    XCTAssertTrue(registriesManager.tookMedicine(d1 - 1.day) != nil)
    XCTAssertTrue(registriesManager.tookMedicine(d1 + 1.day) == nil)
  }
  
  func testFailAddEntryInFuture() {
    XCTAssertTrue(registriesManager.addRegistry( NSDate(), tookMedicine: true).registryAdded)
    XCTAssertFalse(registriesManager.addRegistry( NSDate() + 1.day, tookMedicine: true).registryAdded)
  }
  
  func testModifyEntry() {
    // Modify entry and check if the number of elements did not change.
    let lastCount = registriesManager.getRegistries().count
    XCTAssertTrue(registriesManager.addRegistry(d1 - 4.day, tookMedicine: true, modifyEntry: true).registryAdded)
    XCTAssertEqual(lastCount, registriesManager.getRegistries().count)
    
    // Verify if modification was a success.
    let r = registriesManager.findRegistry(d1 - 4.day)!
    XCTAssertEqual(true, r.tookMedicine)
    XCTAssertEqual(true, r.date.sameDayAs(d1 - 4.day))
  }
  
  func testLimits() {
    if let limits = registriesManager.getLimits() {
      XCTAssertEqual(limits.leastRecent.date, d1 - 9.day)
      XCTAssertEqual(limits.mostRecent.date, d1)
    } else {
      XCTFail("Couldn't find least and most recent entry, fail")
    }
    
    XCTAssertEqual(registriesManager.oldestEntry()!.date, d1 - 9.day)
    XCTAssertEqual(registriesManager.mostRecentEntry()!.date, d1)
  }
  
  func testTookMedicine() {
    let tookMedicineYes = registriesManager.tookMedicine(d1)
    XCTAssertNotNil(tookMedicineYes)
    XCTAssertEqual(tookMedicineYes!.date, d1)
    
    let tookMedicineNo = registriesManager.tookMedicine(d1 - 2.day)
    XCTAssertNil(tookMedicineNo)
    
    let tookMedicinRandom = registriesManager.tookMedicine(d1 - 2.year)
    XCTAssertNil(tookMedicinRandom)
  }
  
  func testEntriesInPeriod() {
    //it's a daily pill
    let entriesInPeriod = registriesManager.allRegistriesInPeriod(d1)
    XCTAssertEqual(1, entriesInPeriod.entries.count)
    XCTAssertFalse(entriesInPeriod.noData)
    
    let entriesInPeriod2 = registriesManager.allRegistriesInPeriod(d1 - 10.day)
    XCTAssertEqual(0, entriesInPeriod2.entries.count)
    XCTAssertTrue(entriesInPeriod2.noData)
  }
  
  func testAditionalFilter() {
    XCTAssertEqual(6, registriesManager.getRegistries(additionalFilter: {(r: Registry) in r.tookMedicine}).count)
    XCTAssertEqual(4, registriesManager.getRegistries(additionalFilter: {(r: Registry) in !r.tookMedicine}).count)
  }
  
  func testCascadeDelete() {
    XCTAssertEqual(Registry.retrieve(Registry.self, context: currentContext).count, 10)
    Medicine.clear(Medicine.self, context: currentContext)
    XCTAssertEqual(Registry.retrieve(Registry.self, context: currentContext).count, 0)
  }
  
  func testWeeklyTookMedicine() {
    m.registerNewMedicine(Medicine.Pill.mefloquine.name(), interval: Medicine.Pill.mefloquine.interval())
    registriesManager = m.getMedicine(Medicine.Pill.mefloquine.name())!.registriesManager
    
    XCTAssertTrue(registriesManager.addRegistry(d1, tookMedicine: true).registryAdded)
    for i in 1...6{
      XCTAssertFalse(registriesManager.tookMedicine(d1 - i.day) != nil)
    }
    for i in 0...6 {
      XCTAssertTrue(registriesManager.tookMedicine(d1 + i.day) != nil)
    }
    
    // Elapsed enough days to restart cycle.
    XCTAssertFalse(registriesManager.tookMedicine(d1 + 7.day) != nil)
    
    // Skip one day.
    XCTAssertTrue(registriesManager.addRegistry(d1 + 8.day, tookMedicine: true).registryAdded)
    XCTAssertFalse(registriesManager.tookMedicine(d1 + 7.day) != nil)
  }
  
  func testWeeklyTookMedicineMixedChoices() {
    m.registerNewMedicine(Medicine.Pill.mefloquine.name(), interval: Medicine.Pill.mefloquine.interval())
    registriesManager = m.getMedicine(Medicine.Pill.mefloquine.name())!.registriesManager
    
    XCTAssertTrue(registriesManager.addRegistry(d1, tookMedicine: false).registryAdded)
    for i in 0...6 {
      XCTAssertFalse(registriesManager.tookMedicine(d1 - i.day) != nil)
    }
    for i in 0...6 {
      XCTAssertFalse(registriesManager.tookMedicine(d1 + i.day) != nil)
    }
    
    let tookWeeklyDate = d1 + 2.day
    XCTAssertTrue(registriesManager.addRegistry(tookWeeklyDate, tookMedicine: false).registryAdded)
    for i in 0...6 {
      XCTAssertFalse(registriesManager.tookMedicine(tookWeeklyDate - i.day) != nil)
    }
    for i in 0...6 {
      XCTAssertFalse(registriesManager.tookMedicine(tookWeeklyDate + i.day) != nil)
    }
    
    // Elapsed enough days to restart cycle.
    XCTAssertFalse(registriesManager.tookMedicine(tookWeeklyDate + 7.day) != nil)
  }
  
  func testLastTimeTaken() {
    XCTAssertEqual(registriesManager.lastPillDate()!, d1)
    registriesManager.removeEntry(d1 - 1.day)
    registriesManager.removeEntry(d1)
    XCTAssertEqual(registriesManager.lastPillDate()!, d1 - 3.day)
  }
}
