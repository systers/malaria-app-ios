import XCTest

class TestMedicineRegistries: XCTestCase {

    var m: MedicineManager?
    var mr: MedicineRegistry?
    var d1 = NSDate()
    
    override func setUp() {
        super.setUp()
        m = MedicineManager.sharedInstance
        mr = MedicineRegistry.sharedInstance
        if m == nil || mr == nil{
            XCTFail("Fail initializing")
        }
        
        m!.setup(Medicine.Pill.Malarone, fireDate: NSDate())
        
        mr!.addRegistry(d1, tookMedicine: true)
        mr!.addRegistry(d1 - 1.day, tookMedicine: true)
        mr!.addRegistry(d1 - 2.day, tookMedicine: false)
        mr!.addRegistry(d1 - 3.day, tookMedicine: true)
        mr!.addRegistry(d1 - 4.day, tookMedicine: false)
        mr!.addRegistry(d1 - 5.day, tookMedicine: true)
        mr!.addRegistry(d1 - 6.day, tookMedicine: true)
        mr!.addRegistry(d1 - 7.day, tookMedicine: false)
        mr!.addRegistry(d1 - 8.day, tookMedicine: true)
        mr!.addRegistry(d1 - 9.day, tookMedicine: false)
    }
    
    override func tearDown() {
        super.tearDown()
        
        mr!.clearCoreData()
    }
    
    func testFindEntriesInBetween(){
        let entries = mr!.getRegistriesInBetween(d1 - 5.day, date2: d1 - 3.day)
        
        if entries.count == 0 {
            XCTFail("No element found")
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
        
        
        //flip the dates, should reproduce the same results
        let entriesFlipped = mr!.getRegistriesInBetween(d1 - 3.day, date2: d1 - 5.day)
        
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
        
        
        //check interval without entries
        XCTAssertEqual(0, mr!.getRegistriesInBetween(d1 - 30.day,  date2: d1 - 25.day).count)
        
        //check interval big enough to fit every entry
        let entries2 = mr!.getRegistriesInBetween(d1 - 50.day, date2: d1 + 50.day)
        XCTAssertEqual(mr!.getRegistries().count, entries2.count)
        
        //single registry
        let entries3 = mr!.getRegistriesInBetween(d1 - 4.day, date2: d1 - 4.day)
        XCTAssertEqual(1, entries3.count)
    }
    
    func testFindEntry(){
        //find existing entry
        var r = mr!.findRegistry(d1 - 4.day)!
        XCTAssertEqual(r.date, d1 - 4.day)
        XCTAssertEqual(r.tookMedicine, false)
        
        //finding inexistent entry
        XCTAssertEqual(true, mr!.findRegistry(d1 - 30.day) == nil)
    }
    
    func testModifyEntry(){
        //modify entry
        mr!.addRegistry(d1 - 4.day, tookMedicine: true)
        let r = mr!.findRegistry(d1 - 4.day)!
        XCTAssertEqual(true, r.tookMedicine)
        XCTAssertEqual(true, NSDate.areDatesSameDay(r.date, dateTwo: d1 - 4.day))
    }

}
