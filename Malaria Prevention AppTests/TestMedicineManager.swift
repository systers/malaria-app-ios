import UIKit
import XCTest
@testable import Malaria_Prevention_App

class TestSetupInsertClear: XCTestCase {
  
  var m: MedicineManager!
  let currentPill = Medicine.Pill.malarone
  
  var currentContext: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    m = MedicineManager(context: currentContext)
    m.registerNewMedicine(currentPill.name(), interval: currentPill.interval())
    m.setCurrentPill(currentPill.name())
  }
  
  override func tearDown() {
    super.tearDown()
    m.clearCoreData()
  }
  
  func testCurrentMedicine() {
    if let medi = m.getCurrentMedicine() {
      XCTAssertEqual(medi.name, Medicine.Pill.malarone.name())
      XCTAssertEqual(medi.interval, 1)
      XCTAssertEqual(medi.registries.count, 0)
    } else {
      XCTFail("Fail initializing:")
    }
  }
  
  func testGetMedicine() {
    if let medi = m.getMedicine(currentPill.name()) {
      XCTAssertEqual(medi.name, Medicine.Pill.malarone.name())
      XCTAssertEqual(medi.interval, 1)
      XCTAssertEqual(medi.registries.count, 0)
    } else {
      XCTFail("Fail initializing:")
    }
  }
  
  func testSetCurrentPill() {
    XCTAssertFalse(m.registerNewMedicine(currentPill.name(), interval: currentPill.interval()))
    XCTAssertTrue(m.registerNewMedicine(Medicine.Pill.doxycycline.name(), interval: Medicine.Pill.doxycycline.interval()))
    XCTAssertEqual(m.getCurrentMedicine()!, m.getMedicine(currentPill.name())!)
  }
  
  func testRegisteredMedicines() {
    XCTAssertEqual(m.getRegisteredMedicines().count, 1)
  }
  
  func testClearMedicines() {
    XCTAssertEqual(true, m.getRegisteredMedicines().count == 1)
    
    m.clearCoreData()
    
    XCTAssertEqual(true, m.getRegisteredMedicines().count == 0)
  }
}