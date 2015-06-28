import XCTest

class TestPlanTrip: XCTestCase {

    let tManager: TripsManager = TripsManager.sharedInstance
    
    let location = "Heaven"
    let currentPill = Medicine.Pill.Malarone
    let cashToBring = 10
    let d1 = NSDate.from(2015, month: 5, day: 8) //monday
    var trip: Trip!
    
    
    override func setUp() {
        super.setUp()
        
        if let t = tManager.createTrip(location, medicine: currentPill, cashToBring: cashToBring, reminderDate: d1){
            trip = t
        }else{
            XCTFail("Setup failed")
        }
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
}
