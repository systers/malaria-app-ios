import XCTest
@testable import Malaria_Prevention_App

class TestMonthAdherence: XCTestCase {
  
  let d1 = NSDate.from(2015, month: 8, day: 1) // Contains 31 days.
  let currentPill = Medicine.Pill.malarone
  
  var currentContext: NSManagedObjectContext!
  var m: MedicineManager!
  var md: Medicine!
  var registriesManager: RegistriesManager!
  var stats: MedicineStats!
  
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
  }
  
  override func tearDown() {
    super.tearDown()
    m.clearCoreData()
  }
  
  func testMonthAdherence() {
    let tenAugust = NSDate.from(2015, month: 8, day: 10)
    XCTAssertTrue(registriesManager.addRegistry(tenAugust, tookMedicine: true).registryAdded)
    XCTAssertEqual(1, stats.monthAdherence(tenAugust, currentDay: tenAugust))
    
    // Missing days count as he didn't take the pill.
    XCTAssertEqual(0.5, stats.monthAdherence(d1, currentDay: tenAugust + 1.day))
    
    let tenJuly = NSDate.from(2015, month: 7, day: 10)
    XCTAssertTrue(registriesManager.addRegistry(tenJuly, tookMedicine: true).registryAdded)
    
    
    // July month, between first entry in 10 July and end of July.
    let numberPillsTaken = stats.numberPillsTaken(tenJuly, date2: NSDate.from(2015, month: 7, day: 31))
    XCTAssertEqual(1, numberPillsTaken)
    let supposedPills = stats.numberSupposedPills(tenJuly, date2: NSDate.from(2015, month: 7, day: 31))
    XCTAssertEqual(Float(numberPillsTaken)/Float(supposedPills), stats.monthAdherence(tenJuly, currentDay: tenAugust))
    
    // In august, between 1 August and ten august (currentDay).
    let numberPillsTaken2 = stats.numberPillsTaken(NSDate.from(2015, month: 8, day: 1), date2: tenAugust)
    XCTAssertEqual(1, numberPillsTaken2)
    let supposedPills2 = stats.numberSupposedPills(NSDate.from(2015, month: 8, day: 1), date2: tenAugust)
    XCTAssertEqual(Float(numberPillsTaken2)/Float(supposedPills2), stats.monthAdherence(tenAugust, currentDay: tenAugust))
    
    // Without entries assume max adherence.
    XCTAssertEqual(1, stats.monthAdherence(NSDate.from(2015, month: 1, day: 1), currentDay: tenAugust))
  }
}