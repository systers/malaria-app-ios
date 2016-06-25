import UIKit
import XCTest
@testable import malaria_ios

class TestMedicineStockManager: XCTestCase {
  
  let secondsTillYesterday: Double = -86400.0
  let twoDaysAgo: Double = -86400.0 * 2
  let secondTillTomorrow: Double = 86400.0
  
  var m: MedicineManager!
  var msm: MedicineStockManager!
  
  let currentPill = Medicine.Pill.Malarone
  
  var currentContext: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    m = MedicineManager(context: currentContext)
    m.registerNewMedicine(currentPill.name(), interval: currentPill.interval())
    m.setCurrentPill(currentPill.name())
  
    msm = MedicineStockManager(medicine: m.getCurrentMedicine()!)
  }
  
  override func tearDown() {
    super.tearDown()
    m.clearCoreData()
  }
  
  // Checks if Core Date successfully updates remaining pills for medicine
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
  
  // Makes sure the updateStock method is not called for a date before the refill date
  // because the reminder shouldn't care about past values in order to update the current stock
  func testUpdateStockWhenDateBeforeRefill() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    msm.addRegistry(NSDate().dateByAddingTimeInterval(secondsTillYesterday), tookMedicine: true)
    
    XCTAssertFalse(medicine.remainingMedicine == 1)
    XCTAssertTrue(medicine.remainingMedicine == 0)
  }
  
  func testAddRegistryBeforeRefill() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 1
    medicine.lastStockRefill = NSDate()
    
    XCTAssertTrue(msm.addRegistry(NSDate().dateByAddingTimeInterval(secondsTillYesterday), tookMedicine: true))
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
    medicine.lastStockRefill = NSDate().dateByAddingTimeInterval(twoDaysAgo)

    XCTAssertTrue(msm.addRegistry(NSDate().dateByAddingTimeInterval(secondsTillYesterday), tookMedicine: true))
  }
  
  func testOnlyUpdateStockIfAddRegistryWasSuccesful() {
    guard let medicine = m.getCurrentMedicine() else {
      XCTFail("Fail initializing:")
      return
    }
    
    medicine.remainingMedicine = 1
    
    let registryAdded = medicine.registriesManager.addRegistry(NSDate(), tookMedicine: true)
    
    if registryAdded.registryAdded && registryAdded.noOtherEntryFound {
      msm.updateStock(true)
      XCTAssertEqual(medicine.remainingMedicine, 0)
    }
    else {
      XCTAssertEqual(medicine.remainingMedicine, 1)
    }
    
  }
}