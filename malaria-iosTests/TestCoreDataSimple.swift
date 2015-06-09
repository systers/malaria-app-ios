import UIKit
import XCTest
import malaria_ios

class TestCoreDataSimple: XCTestCase {

    var m: MedicineManager?
    var mr: MedicineRegistry?
    
    override func setUp() {
        super.setUp()
        m = MedicineManager.sharedInstance
        mr = MedicineRegistry.sharedInstance
        if m == nil || mr == nil{
            XCTFail("Fail initializing")
        }
        
        m!.setup(Medicine.Pill.Malarone, fireDate: NSDate())
    }
    
    override func tearDown() {
        super.tearDown()
        
        //add method to clear CoreData
        mr!.clearCoreData()
    }

    func testSetup(){
        //getting
        let medicine: Medicine? = mr!.getRegisteredMedicine()
        
        if let m = medicine{
            m.print()
            XCTAssertEqual(m.name, Medicine.Pill.Malarone.name())
            XCTAssertEqual(m.weekly, false)
            XCTAssertEqual(m.currentStreak, 0)
            XCTAssertEqual(0, m.registries.count)
        }else{
            XCTFail("Error setting up medicine")
        }
    }
    
    func testClearCoreData(){
        let m1: Medicine? = mr!.getRegisteredMedicine()
        XCTAssertEqual(true, m1 != nil)
        
        let previousCount = m1!.registries.count
        
        mr!.clearCoreData()
        
        let m2: Medicine? = mr!.getRegisteredMedicine()
        XCTAssertEqual(true, m2 == nil)
    }
    
    func testInsertion() {
        
        let d1 = NSDate()
        mr!.addRegistry(d1, tookMedicine: true)
        XCTAssertEqual(d1, mr!.getRegistries()[0].date)
        
        let d2 = d1 + 7.day
        mr!.addRegistry(d2, tookMedicine: false)
        XCTAssertEqual(d2, mr!.getRegistries()[0].date)
        
        let d3 = d2 + 7.day
        mr!.addRegistry(d3, tookMedicine: true)
        XCTAssertEqual(d3, mr!.getRegistries()[0].date)
        
        let registries: [Registry]? = mr!.getRegistries()
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
