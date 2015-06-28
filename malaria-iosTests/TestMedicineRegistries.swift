import XCTest

class TestMedicineRegistries: XCTestCase {

    let m: MedicineManager = MedicineManager.sharedInstance
    
    let d1 = NSDate.from(2015, month: 6, day: 13) //Saturday intentionally
    
    let currentPill = Medicine.Pill.Malarone
    var md: Medicine!
    
    override func setUp() {
        super.setUp()

        
        m.setup(currentPill, fireDate: NSDate())
        
        if let medi = m.getMedicine(currentPill){
            md = medi
        }else{
            XCTFail("Fail initializing:")
        }
        
        md.registriesManager.addRegistry(d1, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 1.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 2.day, tookMedicine: false)
        md.registriesManager.addRegistry(d1 - 3.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 4.day, tookMedicine: false)
        md.registriesManager.addRegistry(d1 - 5.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 6.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 7.day, tookMedicine: false)
        md.registriesManager.addRegistry(d1 - 8.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 9.day, tookMedicine: false)
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
    }
    
    func testFindEntriesInBetween(){
        let entries = md.registriesManager.getRegistries(date1: d1 - 5.day, date2: d1 - 3.day)
        
        if entries.count != 3 {
            XCTFail("Incorrect number of elements")
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
        let entriesFlipped = md.registriesManager.getRegistries(date1:d1 - 3.day, date2: d1 - 5.day)
        
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
        XCTAssertEqual(0, md.registriesManager.getRegistries(date1:d1 - 30.day,  date2: d1 - 25.day).count)
        
        //check interval big enough to fit every entry
        let entries2 = md.registriesManager.getRegistries(date1:d1 - 50.day, date2: d1 + 50.day)
        XCTAssertEqual(md.registriesManager.getRegistries().count, entries2.count)
        
        //single registry
        let entries3 = md.registriesManager.getRegistries(date1:d1 - 4.day, date2: d1 - 4.day)
        XCTAssertEqual(1, entries3.count)
    }
    
    func testFindEntry(){
        //find existing entry
        var r = md.registriesManager.findRegistry(d1 - 4.day)!
        XCTAssertEqual(r.date, d1 - 4.day)
        XCTAssertEqual(r.tookMedicine, false)
        
        //finding inexistent entry
        XCTAssertEqual(true, md.registriesManager.findRegistry(d1 - 30.day) == nil)
    }
    
    func testAlreadyRegisteredWeeklyPill(){
        let weeklyPill = Medicine.Pill.Mefloquine
        m.registerNewMedicine(weeklyPill)

        var weekly: Medicine!
        if let w = m.getMedicine(weeklyPill){
            weekly = w
        }else{
            XCTFail("Failure registering weekly pill")
        }
        
        
        //Saturday = 0, Sunday = 1, etc
        var dStartWeek = d1 + NSCalendar.currentCalendar().firstWeekday.day
        
        XCTAssertTrue(weekly.registriesManager.addRegistry(dStartWeek, tookMedicine: true))

        XCTAssertFalse(weekly.registriesManager.alreadyRegistered(dStartWeek - 1.day))
        XCTAssertTrue(weekly.registriesManager.alreadyRegistered(dStartWeek + 1.day))
        XCTAssertTrue(weekly.registriesManager.alreadyRegistered(dStartWeek + 2.day))
        XCTAssertTrue(weekly.registriesManager.alreadyRegistered(dStartWeek + 3.day))
        XCTAssertTrue(weekly.registriesManager.alreadyRegistered(dStartWeek + 4.day))
        XCTAssertTrue(weekly.registriesManager.alreadyRegistered(dStartWeek + 5.day))
        XCTAssertTrue(weekly.registriesManager.alreadyRegistered(dStartWeek + 6.day))
        XCTAssertFalse(weekly.registriesManager.alreadyRegistered(dStartWeek + 7.day))
    }
    
    func testAlreadyRegisteredDailyPill(){
        XCTAssertTrue(md.registriesManager.alreadyRegistered(d1))
        XCTAssertTrue(md.registriesManager.alreadyRegistered(d1 - 1.day))
        XCTAssertFalse(md.registriesManager.alreadyRegistered(d1 + 1.day))
    }
    
    func testFailAddEntryInFuture(){
        XCTAssertTrue(md.registriesManager.addRegistry( NSDate(), tookMedicine: true))
        XCTAssertFalse(md.registriesManager.addRegistry( NSDate() + 1.day, tookMedicine: true))
    }
    
    func testModifyEntry(){
        //modify entry and check if the number of elements did not change
        let lastCount = md.registriesManager.getRegistries().count
        XCTAssertTrue(md.registriesManager.addRegistry( d1 - 4.day, tookMedicine: true, modifyEntry: true))
        XCTAssertEqual(lastCount, md.registriesManager.getRegistries().count)
        
        //verify if modification was a success
        let r = md.registriesManager.findRegistry(d1 - 4.day)!
        XCTAssertEqual(true, r.tookMedicine)
        XCTAssertEqual(true, NSDate.areDatesSameDay(r.date, dateTwo: d1 - 4.day))
    }
    
    func testCascadeDelete(){
        XCTAssertEqual(Registry.retrieve(Registry.self).count, 10)
        Medicine.clear(Medicine.self)
        XCTAssertEqual(Registry.retrieve(Registry.self).count, 0)
    }
}
