import XCTest

class TestMedicineStatistics: XCTestCase {

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
        mr!.addRegistry(d1 - 2.day, tookMedicine: true)
        mr!.addRegistry(d1 - 3.day, tookMedicine: true)
        mr!.addRegistry(d1 - 4.day, tookMedicine: true)
        mr!.addRegistry(d1 - 5.day, tookMedicine: true)
        mr!.addRegistry(d1 - 6.day, tookMedicine: true)
        mr!.addRegistry(d1 - 7.day, tookMedicine: true)
        mr!.addRegistry(d1 - 8.day, tookMedicine: true)
        mr!.addRegistry(d1 - 9.day, tookMedicine: true)
    }
    
    override func tearDown() {
        super.tearDown()
        mr!.clearCoreData()
    }
    
    func testPillStreak(){
        XCTAssertEqual(10, m!.pillStreak())
        XCTAssertEqual(6, m!.pillStreak(registries: mr!.getRegistriesInBetween(d1, date2: d1 - 5.day)))
    
        //miss one pill
        mr!.addRegistry(d1 - 5.day, tookMedicine: false)
        XCTAssertEqual(0, m!.pillStreak(registries: mr!.getRegistriesInBetween(d1 - 9.day, date2: d1 - 5.day)))
        XCTAssertEqual(5, m!.pillStreak(registries: mr!.getRegistriesInBetween(d1, date2: d1 - 5.day)))
        
        //did not took a pill more recently
        mr!.addRegistry(d1 + 1.day, tookMedicine: false)
        XCTAssertEqual(0, m!.pillStreak())
    }
    
    func testSupposedPills(){
        XCTAssertEqual(10, m!.numberSupposedPills())
        
        //add one pill
        mr!.addRegistry(d1 + 1.day, tookMedicine: false)
        XCTAssertEqual(11, m!.numberSupposedPills())
        
        //miss one pill
        mr!.addRegistry(d1 + 2.day, tookMedicine: false)
        XCTAssertEqual(12, m!.numberSupposedPills())
        
        //miss one pill in the past
        mr!.addRegistry(d1 - 5.day, tookMedicine: false)
        XCTAssertEqual(3, m!.numberSupposedPills(registries: mr!.getRegistriesInBetween(d1 - 6.day, date2: d1 - 4.day)))
    }
    
    func testPillsTaken(){
        XCTAssertEqual(10, m!.numberPillsTaken())
        XCTAssertEqual(6, m!.numberPillsTaken(registries: mr!.getRegistriesInBetween(d1, date2: d1 - 5.day)))
        
        //add one pill
        mr!.addRegistry(d1 + 1.day, tookMedicine: true)
        XCTAssertEqual(11, m!.numberPillsTaken())
        
        //miss one pill
        mr!.addRegistry(d1 + 2.day, tookMedicine: false)
        XCTAssertEqual(11, m!.numberPillsTaken())
        
        //miss one pill in the past
        mr!.addRegistry(d1 - 5.day, tookMedicine: false)
        XCTAssertEqual(2, m!.numberPillsTaken(registries: mr!.getRegistriesInBetween(d1 - 6.day, date2: d1 - 4.day)))
    }
    
    func testAdherence(){
        XCTAssertEqual(1, m!.pillAdherence())
        
        //add one pill
        mr!.addRegistry(d1 + 1.day, tookMedicine: true)
        XCTAssertEqual(1, m!.pillAdherence())
        
        //miss one pill
        mr!.addRegistry(d1 + 2.day, tookMedicine: false)
        XCTAssertEqual(Float(m!.numberPillsTaken())/Float(m!.numberSupposedPills()), m!.pillAdherence())
        
        //miss one pill in the past
        mr!.addRegistry(d1 - 5.day, tookMedicine: false)
        let filter = mr!.getRegistriesInBetween(d1 - 6.day, date2: d1 - 4.day)
        let expectedAdherenceFilter = Float(m!.numberPillsTaken(registries: filter))/Float(m!.numberSupposedPills(registries: filter))
        XCTAssertEqual(expectedAdherenceFilter, m!.pillAdherence(registries: filter))
    }
    
    func testTookMedicine(){
        //given a date, check if took medicine or not. Used in DidTookPillViewController. It takes into account if the pill is weekly or not
    
    }
    
    func testShouldReshedulePillReminder(){
        //only applicable to weekly pills
        /* If the user fails to take their medication mid-way through a week, and a full 7 days goes by without the medication being recorded, on DayX+7 the system will start again and allow the user to enter new data for that week. So if the user is supposed to take medications on Mondays, and next Monday arrives with no data entry, the day and date at the top will go back to black text, and the system will now record data for that new week and consider the previous week a missed week.*/
    }
}
