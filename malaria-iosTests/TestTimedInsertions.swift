import XCTest

class TestTimedInsertions: XCTestCase {
    
    
    let m: MedicineManager = MedicineManager.sharedInstance
    
    let d1 = NSDate.from(2015, month: 6, day: 6) + NSCalendar.currentCalendar().firstWeekday.day //start of the week
    let weeklyPill = Medicine.Pill.Mefloquine
    let dailyPill = Medicine.Pill.Malarone
    
    var daily: Medicine!
    var weekly: Medicine!
    
    override func setUp() {
        super.setUp()

        m.registerNewMedicine(weeklyPill)
        m.registerNewMedicine(dailyPill)
        
        if let m1 = m.findMedicine(dailyPill),
           let m2 = m.findMedicine(weeklyPill){
            daily = m1
            weekly = m2
        }else{
            XCTFail("Fail initializing:")
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
    }

    func testDailyInsert(){
        
        XCTAssertTrue(daily.registriesManager.addRegistry(d1, tookMedicine: false))
        XCTAssertFalse(daily.registriesManager.addRegistry(d1, tookMedicine: false))
        
        XCTAssertEqual(1, daily.registriesManager.getRegistries().count)
        
        
        XCTAssertTrue(daily.registriesManager.addRegistry(d1 - 1.day, tookMedicine: false))
        XCTAssertTrue(daily.registriesManager.addRegistry(d1 + 1.day, tookMedicine: false))
        
        XCTAssertEqual(3, daily.registriesManager.getRegistries().count)
        
    }
    
    func testWeeklyInsert(){
        XCTAssertTrue(weekly.registriesManager.addRegistry(d1, tookMedicine: false))
        XCTAssertFalse(weekly.registriesManager.addRegistry(d1 + 1.day, tookMedicine: true))
        XCTAssertFalse(weekly.registriesManager.addRegistry(d1 + 2.day, tookMedicine: true))
        XCTAssertFalse(weekly.registriesManager.addRegistry(d1 + 3.day, tookMedicine: true))
        XCTAssertFalse(weekly.registriesManager.addRegistry(d1 + 4.day, tookMedicine: true))
        XCTAssertFalse(weekly.registriesManager.addRegistry(d1 + 5.day, tookMedicine: true))
        XCTAssertFalse(weekly.registriesManager.addRegistry(d1 + 6.day, tookMedicine: true))
        XCTAssertEqual(1, weekly.registriesManager.getRegistries().count)
        XCTAssertTrue(weekly.registriesManager.addRegistry(d1 + 1.week, tookMedicine: true))
        XCTAssertEqual(2, weekly.registriesManager.getRegistries().count)
    }
    
    func testDailyModifyPastEntry(){
        XCTAssertTrue(weekly.registriesManager.addRegistry(d1, tookMedicine: false))
        XCTAssertTrue(weekly.registriesManager.addRegistry(d1, tookMedicine: true, modifyEntry: true))
        XCTAssertEqual(1, weekly.registriesManager.getRegistries().count)
        XCTAssertTrue(weekly.registriesManager.getRegistries()[0].tookMedicine)
    }
    
    func testDifferentTimes(){
        XCTAssertTrue(daily.registriesManager.addRegistry(d1, tookMedicine: false))
        let b = d1 + 1.minute
        XCTAssertEqual(1, daily.registriesManager.getRegistries(date1: b, date2: b).count)
    }
}
