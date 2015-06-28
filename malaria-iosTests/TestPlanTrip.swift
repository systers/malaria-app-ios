import XCTest

class TestPlanTrip: XCTestCase {

    let tManager: TripsManager = TripsManager.sharedInstance
    
    let location = "Heaven"
    let currentPill = Medicine.Pill.Malarone
    let cashToBring: Int64 = 10
    let d1 = NSDate.from(2015, month: 5, day: 8) //monday
    var trip: Trip!
    
    
    override func setUp() {
        super.setUp()
        trip = tManager.createTrip(location, medicine: currentPill, cashToBring: cashToBring, reminderDate: d1)
    }
    
    override func tearDown() {
        super.tearDown()
        tManager.clearCoreData()
    }
    
    func testGetTrip(){
        if let t = tManager.getTrip(){
            XCTAssertEqual(t, trip)
            XCTAssertEqual(t.location, location)
            XCTAssertEqual(t.medicine, currentPill.name())
            XCTAssertEqual(t.cashToBring, cashToBring)
            XCTAssertEqual(t.reminderDate, d1)
        }else{
            XCTFail("Trip wasn't created")
        }
    }
    
    func testCreateAnotherTrip(){
        let location2 = "Alabama"
        let pill2 = Medicine.Pill.Mefloquine
        let cash: Int64 = 9000
        let reminderDate2 = d1 + 10.day
        
        trip = tManager.createTrip(location2, medicine: pill2, cashToBring: cash, reminderDate: reminderDate2)
        
        XCTAssertEqual(trip.location, location2)
        XCTAssertEqual(trip.medicine, pill2.name())
        XCTAssertEqual(trip.cashToBring, cash)
        XCTAssertEqual(trip.reminderDate, reminderDate2)
        
        if let t = tManager.getTrip(){
            XCTAssertEqual(t.location, location2)
            XCTAssertEqual(t.medicine, pill2.name())
            XCTAssertEqual(t.cashToBring, cash)
            XCTAssertEqual(t.reminderDate, reminderDate2)
        }else{
            XCTFail("Trip wasn't created")
        }
    }
    
    func testAddItems(){
        trip.itemsManager.addItem("lantern", quantity: 1)
        trip.itemsManager.addItem("Stress Ball", quantity: 2)
        
        
        if let lantern = trip.itemsManager.findItem("lantern"){
            XCTAssertEqual(lantern.number, 1)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        if let lantern = trip.itemsManager.findItem("Lantern"){
            XCTAssertEqual(lantern.number, 1)
        }else{
            XCTFail("findItem must be case insensitive")
        }
        
        if let lantern = trip.itemsManager.findItem("Stress Ball"){
            XCTAssertEqual(lantern.number, 2)
        }
        
        //check case insensitive
        XCTAssertTrue(trip.itemsManager.getItems().count == 2)
    }
    
    
    func testAddQuantity(){
        trip.itemsManager.addItem("lantern", quantity: 1)
        
        if let lantern = trip.itemsManager.findItem("lantern"){
            XCTAssertEqual(lantern.number, 1)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        //add more 3 lanterns to the trip ( 3 + 1)
        trip.itemsManager.addItem("lantern", quantity: 3)
        
        if let lantern = trip.itemsManager.findItem("lantern"){
            XCTAssertEqual(lantern.number, 4)
        }else{
            XCTFail("findItem lantern not found")
        }
    }
    
    func testRemoveItem(){
        //test simple decrement
        trip.itemsManager.addItem("lantern", quantity: 6)
        trip.itemsManager.removeItem("lantern", quantity: 2)
        
        if let lantern = trip.itemsManager.findItem("lantern"){
            XCTAssertEqual(lantern.number, 4)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        //test removing more elements that there is. The item must be removed
        trip.itemsManager.removeItem("lantern", quantity: 30)
        
        if let lantern = trip.itemsManager.findItem("lantern"){
            XCTFail("item was not removed despite")
        }
        
        
        //adding again
        trip.itemsManager.addItem("lantern", quantity: 9)
        if let lantern = trip.itemsManager.findItem("LANTERN"){
            XCTAssertEqual(lantern.number, 9)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        //removing again
        trip.itemsManager.removeItem("lantern")
        if let lantern = trip.itemsManager.findItem("lantern"){
            XCTFail("item was not removed despite")
        }
    }
    
    func testCascadeDelete(){
        trip.itemsManager.addItem("lantern", quantity: 6)
        trip.itemsManager.addItem("medalion", quantity: 2)
        
        XCTAssertEqual(Item.retrieve(Item.self).count, 2)
        Trip.clear(Trip.self)
        XCTAssertEqual(Item.retrieve(Item.self).count, 0)
    }
}
