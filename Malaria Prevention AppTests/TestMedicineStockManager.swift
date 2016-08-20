import UIKit
import XCTest
@testable import Malaria_Prevention_App

class TestMedicineStockManager: XCTestCase {
  
  var m: MedicineManager!
  var msm: MedicineStockManager!
  
  let currentPill = Medicine.Pill.malarone
  
  var currentContext: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    m = MedicineManager(context: currentContext)
    m.registerNewMedicine(currentPill.name(),
                          interval: currentPill.interval())
    m.setCurrentPill(currentPill.name())
    
    msm = MedicineStockManager(medicine: m.getCurrentMedicine()!)
  }
  
  override func tearDown() {
    super.tearDown()
    m.clearCoreData()
  }
  
  // Checks if Core Date successfully updates remaining pills for medicine.
  func testUpdateStock() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 1
    
    msm.updateStock(true)
    XCTAssertEqual(medicine.remainingMedicine, 0)
    
    msm.updateStock(false)
    XCTAssertEqual(medicine.remainingMedicine, 1)
  }
  
  // Tests what happens when user presses Yes -> It should remove a pill.
  // If the user pressed No, after he just pressed Yes, the pill should return in his inventory.
  
  func testUserHasEnoughPillsToPressYes() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 0
    
    XCTAssertFalse(msm.addRegistry(NSDate(), tookMedicine: true))
    
    medicine.remainingMedicine = 1
    
    XCTAssertTrue(msm.addRegistry(NSDate(), tookMedicine: true))
  }
  
  // This case is when the user doesn't modify an entry to No and getting his pill back.
  // In this case, the user pressed No without needing to receive any pills back, because he never pressed Yes.
  
  func testUserSetNoWithoutPressingYesFirst() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 0
    
    medicine.registriesManager.addRegistry(NSDate(), tookMedicine: true, modifyEntry: false)
    
    XCTAssertEqual(medicine.remainingMedicine, 0)
  }
  
  func testUserSetNoAfterShePressedYes() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 1
    
    medicine.registriesManager.addRegistry(NSDate(), tookMedicine: true, modifyEntry: false)
    
    medicine.registriesManager.addRegistry(NSDate(), tookMedicine: false, modifyEntry: false)
    
    XCTAssertEqual(medicine.remainingMedicine, 1)
  }
  
  // Makes sure the updateStock method is not called for a date before the refill date
  // because the reminder shouldn't care about past values in order to update the current stock
  
  func testUpdateStockWhenDateBeforeRefill() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    msm.addRegistry(NSDate() - 1.day, tookMedicine: true)
    
    XCTAssertFalse(medicine.remainingMedicine == 1)
  }
  
  func testAddRegistryBeforeRefill() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 1
    medicine.lastStockRefill = NSDate()
    
    XCTAssertTrue(msm.addRegistry(NSDate() - 1.day, tookMedicine: true))
  }
  
  func testAddRegistrySameDayAsRefill() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 1
    medicine.lastStockRefill = NSDate()
    
    XCTAssertTrue(msm.addRegistry(NSDate(), tookMedicine: true))
  }
  
  func testAddRegistryAfterRefill() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 1
    medicine.lastStockRefill = NSDate() - 2.day
    
    XCTAssertTrue(msm.addRegistry(NSDate() - 1.day, tookMedicine: true))
  }
  
  func testOnlyUpdateStockIfAddRegistryWasSuccesful() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 1
    
    let registryAdded = medicine.registriesManager.addRegistry(NSDate(), tookMedicine: true)
    
    if registryAdded.registryAdded && registryAdded.otherEntriesFound {
      msm.updateStock(true)
      XCTAssertEqual(medicine.remainingMedicine, 0)
    }
    else {
      XCTAssertEqual(medicine.remainingMedicine, 1)
    }
  }
}