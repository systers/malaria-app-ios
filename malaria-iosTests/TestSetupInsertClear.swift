import UIKit
import XCTest
import malaria_ios

class TestSetupInsertClear: XCTestCase {

    let m: MedicineManager = MedicineManager.sharedInstance
    let currentPill = Medicine.Pill.Malarone
    var md: Medicine!
    
    override func setUp() {
        super.setUp()
        
        m.setup(currentPill, fireDate: NSDate())
        if let medi = m.findMedicine(currentPill){
            md = medi
        }else{
            XCTFail("Fail initializing:")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        m.clearCoreData()
    }

    func testSetup(){
        //getting
        let medicine: Medicine? = m.getCurrentMedicine()
        
        if let m = medicine{
            XCTAssertEqual(m.name, Medicine.Pill.Malarone.name())
            XCTAssertEqual(m.weekly, false)
            XCTAssertEqual(0, m.registries.count)
        }else{
            XCTFail("Error setting up medicine")
        }
    }
    
    func testClearCoreData(){
        let medicines = m.getRegisteredMedicines()
        XCTAssertEqual(true, medicines.count == 1)
        
        m.clearCoreData()
        
        let medicines2 = m.getRegisteredMedicines()
        XCTAssertEqual(true, medicines2.count == 0)
    }
    
    func testInsertion() {
        let d1 = NSDate() - 7.day
        XCTAssertTrue(md.registriesManager.addRegistry(d1, tookMedicine: true))
        XCTAssertEqual(d1, md.registriesManager.getRegistries()[0].date)
        
        let d2 = d1 + 1.day
        XCTAssertTrue(md.registriesManager.addRegistry(d2, tookMedicine: false))
        XCTAssertEqual(d2, md.registriesManager.getRegistries()[0].date)
        
        let d3 = d2 + 1.day
        XCTAssertTrue(md.registriesManager.addRegistry(d3, tookMedicine: true))
        XCTAssertEqual(d3, md.registriesManager.getRegistries()[0].date)
        
        let registries: [Registry]? = md.registriesManager.getRegistries()
        if let array = registries{
            if(array.count != 3){
                XCTFail("Error registering pills")
            }
            
            let r1: Registry = array[0]
            XCTAssertEqual(r1.date, d3)
            XCTAssertEqual(r1.tookMedicine, true)
            
            
            let r2: Registry = array[1]
            XCTAssertEqual(r2.date, d2)
            XCTAssertEqual(r2.tookMedicine, false)
            
            let r3: Registry = array[2]
            XCTAssertEqual(r3.date, d1)
            XCTAssertEqual(r3.tookMedicine, true)
        }else{
            XCTFail("Error inserting registries pills")
        }
    }
}
