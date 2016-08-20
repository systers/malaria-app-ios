import UIKit
import XCTest
@testable import Malaria_Prevention_App

class TestSyncManager: XCTestCase {
  var sm: SyncManager!
  
  var expectation: XCTestExpectation?
  var completionCalled = false
  
  var currentContext: NSManagedObjectContext!
  override func setUp() {
    super.setUp()
    
    completionCalled = false
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    sm = SyncManager(context: currentContext)
  }
  
  override func tearDown() {
    super.tearDown()
    for (_, endpoint) in sm.endpoints{
      endpoint.clearFromDatabase(currentContext)
    }
  }
  
  func completionHandler(url: String, error: NSError?) {
    completionCalled = true
    expectation!.fulfill()
  }
  
  func genericTest(path: String, type : NSManagedObject.Type?, additionalTests: (()->())? = nil) {
    expectation = expectationWithDescription("\(path)_callback")
    
    sm.sync(path, save: true, completionHandler: completionHandler)
    
    var done: Bool = false
    
    waitForExpectationsWithTimeout(15, handler: { error in
      if let error = error {
        XCTFail("\(error.localizedDescription)")
      }
      
      if !self.completionCalled{
        XCTFail("completion handler wasn't called")
      }
      
      // Assure only one object per endpoint.
      if let t = type {
        XCTAssertEqual(t.retrieve(t.self, context: self.currentContext).count, 1)
      }
      
      additionalTests?()
      
      done = true
    })
    
    if(!done) {
      XCTFail("Expectation not called!")
    }
  }
  
  func testSyncAll() {
    expectation = expectationWithDescription("syncall")
    
    
    sm.syncAll({ Void in self.expectation!.fulfill() })
    var done: Bool = false
    waitForExpectationsWithTimeout(60, handler: { error in
      if let error = error {
        XCTFail("\(error.localizedDescription)")
      }
      
      XCTAssertEqual(Posts.retrieve(Posts.self, context: self.currentContext).count, 1)
      
      done = true
    })
    
    if(!done) {
      XCTFail("Expectation not called!")
    }
  }
  
  func testBadUrl() {
    genericTest("Bad url", type: nil)
  }
  
  func testPosts() {
    func additionalTests() {
      let endpointInfoArray = Posts.retrieve(Posts.self, context: currentContext)
      XCTAssertEqual(endpointInfoArray.count, 1)
      XCTAssertNotEqual(Post.retrieve(Post.self, context: currentContext).count, 0)
      XCTAssertNotEqual(endpointInfoArray[0].posts.count, 0)
      
    }
    
    genericTest(EndpointType.Posts.path(), type: Posts.self, additionalTests: additionalTests)
  }
}