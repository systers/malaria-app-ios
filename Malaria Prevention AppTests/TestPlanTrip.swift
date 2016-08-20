import XCTest
@testable import Malaria_Prevention_App

class TestPlanTrip: XCTestCase {
  
  var tManager: TripsManager!
  
  let location = "Heaven"
  let currentPill = Medicine.Pill.malarone
  let cashToBring: Int64 = 10
  let d1 = NSDate.from(2015, month: 5, day: 8) // Monday.
  let d2 = NSDate.from(2015, month: 5, day: 8) + 1.week // Monday.
  let reminderTime = NSDate.from(1, month: 1, day: 1, hour: 9, minute: 0)
  var trip: Trip!
  var itemsManager: ItemsManager!
  var currentContext: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    
    tManager = TripsManager(context: currentContext)
    trip = tManager.createTrip(location, medicine: currentPill.name(), departure: d1, arrival: d2, timeReminder: reminderTime)
    
    itemsManager = trip.itemsManager
  }
  
  override func tearDown() {
    super.tearDown()
    tManager.clearCoreData()
  }
  
  func testGetTrip() {
    if let t = tManager.getTrip() {
      XCTAssertEqual(t, trip)
      XCTAssertEqual(t.location, location)
      XCTAssertEqual(t.medicine, currentPill.name())
      XCTAssertEqual(t.departure, d1)
      XCTAssertEqual(t.arrival, d2)
      XCTAssertTrue(t.reminderTime.sameClockTimeAs(reminderTime))
    } else {
      XCTFail("Trip wasn't created")
    }
  }
  
  func testCreateAnotherTrip() {
    let location2 = "Alabama"
    let pill2 = Medicine.Pill.mefloquine
    let departure2 = d1 + 10.day
    let arrival2 = d1 + 20.day
    
    trip = tManager.createTrip(location2, medicine: pill2.name(), departure: departure2, arrival: arrival2, timeReminder: reminderTime)
    
    XCTAssertEqual(trip.location, location2)
    XCTAssertEqual(trip.medicine, pill2.name())
    XCTAssertEqual(trip.departure, departure2)
    XCTAssertEqual(trip.arrival, arrival2)
    XCTAssertTrue(trip.reminderTime.sameClockTimeAs(reminderTime))
    
    if let t = tManager.getTrip() {
      XCTAssertEqual(t.location, location2)
      XCTAssertEqual(t.medicine, pill2.name())
      XCTAssertEqual(trip.departure, departure2)
      XCTAssertEqual(trip.arrival, arrival2)
      XCTAssertTrue(trip.reminderTime.sameClockTimeAs(reminderTime))
      
    } else {
      XCTFail("Trip wasn't created")
    }
  }
  
  
  func testAddItems() {
    itemsManager.addItem("lantern", quantity: 1)
    XCTAssertEqual(trip.items.count, 1)
    
    itemsManager.addItem("Stress Ball", quantity: 2)
    XCTAssertEqual(trip.items.count, 2)
    
    
    if let  lantern = itemsManager.findItem("lantern") {
      XCTAssertEqual(lantern.quantity, 1)
    } else {
      XCTFail("findItem lantern not found")
    }
    
    if let streessBall = itemsManager.findItem("Stress Ball") {
      XCTAssertEqual(streessBall.quantity, 2)
    }
    
    // Check case insensitive.
    XCTAssertTrue(itemsManager.getItems().count == 2)
  }
  
  
  func testAddQuantity() {
    itemsManager.addItem("lantern", quantity: 1)
    
    if let lantern = itemsManager.findItem("lantern") {
      XCTAssertEqual(lantern.quantity, 1)
    }else{
      XCTFail("findItem lantern not found")
    }
    
    XCTAssertEqual(trip.items.count, 1)
    
    // Add more 3 lanterns to the trip (3 + 1).
    itemsManager.addItem("lantern", quantity: 3)
    
    if let lantern = itemsManager.findItem("lantern") {
      XCTAssertEqual(lantern.quantity, 4)
    }else{
      XCTFail("findItem lantern not found")
    }
    
    XCTAssertEqual(trip.items.count, 1)
  }
  
  func testRemoveItem() {
    // Test simple decrement.
    itemsManager.addItem("lantern", quantity: 6)
    itemsManager.removeItem("lantern", quantity: 2)
    
    if let lantern = itemsManager.findItem("lantern") {
      XCTAssertEqual(lantern.quantity, 4)
    }else{
      XCTFail("findItem lantern not found")
    }
    
    XCTAssertEqual(trip.items.count, 1)
    
    // Test removing more elements that there is. The item must be removed.
    itemsManager.removeItem("lantern", quantity: 30)
    
    XCTAssertNil(itemsManager.findItem("lantern"), "item was not removed")
    
    // Adding again.
    itemsManager.addItem("lantern", quantity: 9)
    if let lantern = itemsManager.findItem("LANTERN") {
      XCTAssertEqual(lantern.quantity, 9)
    }else{
      XCTFail("findItem lantern not found")
    }
    
    XCTAssertEqual(trip.items.count, 1)
    
    // Removing again.
    itemsManager.removeItem("lantern")
    
    XCTAssertNil(itemsManager.findItem("lantern"), "item was not removed")
    
    XCTAssertEqual(trip.items.count, 0)
  }
  
  func testCheckItems() {
    itemsManager.addItem("lantern", quantity: 9)
    itemsManager.addItem("ball", quantity: 1)
    
    // Default value.
    XCTAssertFalse(itemsManager.findItem("lantern")!.check)
    XCTAssertFalse(itemsManager.findItem("ball")!.check)
    
    // Check every item.
    itemsManager.checkItem(["lantern", "ball"])
    XCTAssertTrue(itemsManager.findItem("lantern")!.check)
    XCTAssertTrue(itemsManager.findItem("ball")!.check)
    
    // Uncheck every item.
    itemsManager.uncheckItem(["lantern", "ball"])
    XCTAssertFalse(itemsManager.findItem("lantern")!.check)
    XCTAssertFalse(itemsManager.findItem("ball")!.check)
    
    // Check only ball to true.
    itemsManager.checkItem(["lantern"])
    XCTAssertTrue(itemsManager.findItem("lantern")!.check)
    
    // Toggle all.
    itemsManager.toggleCheckItem(["lantern", "ball"])
    XCTAssertFalse(itemsManager.findItem("lantern")!.check)
    XCTAssertTrue(itemsManager.findItem("ball")!.check)
  }
  
  func testLocationHistory() {
    let history = tManager.getHistory(10)
    XCTAssertEqual(1, history.count)
    
    XCTAssertEqual(history.first!.location, location)
    XCTAssertEqual(history.first!.timestamp, d1)
    
    tManager.createTrip("LA", medicine: currentPill.name(), departure: d1 + 1.day, arrival: d2, timeReminder: reminderTime)
    let history2 = tManager.getHistory(10)
    XCTAssertEqual(2, history2.count)
    
    XCTAssertEqual("LA", history2.first!.location)
    XCTAssertEqual(location, history2[1].location)
    
    // There are 2, but we only limit to one.
    let history3 = tManager.getHistory(1)
    XCTAssertEqual(1, history3.count)
    
    // Create same trip, shouldn't record again.
    tManager.createTrip("LA", medicine: currentPill.name(), departure: d1 + 1.day, arrival: d2, timeReminder: reminderTime)
    let history4 = tManager.getHistory(10)
    XCTAssertEqual(2, history4.count)
    
    // Test history limit (15), there already 2.
    tManager.createTrip("3", medicine: currentPill.name(), departure: d1 + 2.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("4", medicine: currentPill.name(), departure: d1 + 3.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("5", medicine: currentPill.name(), departure: d1 + 4.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("6", medicine: currentPill.name(), departure: d1 + 5.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("7", medicine: currentPill.name(), departure: d1 + 6.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("8", medicine: currentPill.name(), departure: d1 + 7.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("9", medicine: currentPill.name(), departure: d1 + 8.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("10", medicine: currentPill.name(), departure: d1 + 9.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("11", medicine: currentPill.name(), departure: d1 + 10.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("12", medicine: currentPill.name(), departure: d1 + 11.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("12", medicine: currentPill.name(), departure: d1 + 12.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("13", medicine: currentPill.name(), departure: d1 + 13.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("14", medicine: currentPill.name(), departure: d1 + 14.day, arrival: d2, timeReminder: reminderTime)
    tManager.createTrip("15", medicine: currentPill.name(), departure: d1 + 15.day, arrival: d2, timeReminder: reminderTime)
    XCTAssertEqual(15, tManager.getHistory(Int.max).count)
    
    // One above the limit.
    tManager.createTrip("16", medicine: currentPill.name(), departure: d1 + 16.day, arrival: d2, timeReminder: reminderTime)
    XCTAssertEqual(15, tManager.getHistory(Int.max).count)
    
    // Should have deleted the oldest entry at location.
    let mostRecentHistory = tManager.getHistory(Int.max).last!
    XCTAssertEqual("LA", mostRecentHistory.location)
    XCTAssertEqual(d1 + 1.day, mostRecentHistory.timestamp)
  }
  
  func testCascadeDelete() {
    XCTAssertEqual(Item.retrieve(Item.self, context: currentContext).count, 0)
    itemsManager.addItem("lantern", quantity: 6)
    itemsManager.addItem("medalion", quantity: 2)
    XCTAssertEqual(Item.retrieve(Item.self, context: currentContext).count, 2)
    
    Trip.clear(Trip.self, context: currentContext)
    XCTAssertEqual(Item.retrieve(Item.self, context: currentContext).count, 0)
  }
}