import UIKit
import XCTest

class TestSyncManager: XCTestCase {
    let sm = SyncManager.sharedInstance
    
    var expectation: XCTestExpectation?
    var successCalled = false
    var failureCalled = false
    
    override func setUp() {
        super.setUp()
        
        successCalled = false
        failureCalled = false
    }
    
    override func tearDown() {
        super.tearDown()
        for (path, endpoint) in sm.endpoints{
            endpoint.clearFromDatabase()
        }
    }
    
    func successHandler(url: String, object: NSManagedObject){
        successCalled = true
        expectation!.fulfill()
    }
    
    func failureHandler(url: String, error: NSError?){
        failureCalled = true
        expectation!.fulfill()
    }
    
    func genericTest(path: String, type : NSManagedObject.Type?){
        expectation = expectationWithDescription("\(path)_callback")
        
        sm.sync(path, save: true, failureHandler: failureHandler, successHandler: successHandler)
        
        var done: Bool = false
        
        waitForExpectationsWithTimeout(15, handler: { error in
            if let error = error {
                XCTFail("\(error.localizedDescription)")
            }
            
            if !self.failureCalled && !self.successCalled{
                XCTFail("Nor success nor failures callbacks were called")
            }
            
            //assure only one object per endpoint
            if let t = type{
                XCTAssertEqual(t.retrieve(t.self).count, 1)
            }
            
            done = true
        })
        
        if(!done){
            XCTFail("Expectation not called!")
        }
    }
    
    func testSyncAll(){
        expectation = expectationWithDescription("syncall")
        
        func completition(){
            expectation!.fulfill()
        }
        
        sm.syncAll(completitionHandler: completition)
        
        var done: Bool = false
        
        waitForExpectationsWithTimeout(60, handler: { error in
            if let error = error {
                XCTFail("\(error.localizedDescription)")
            }
            
            XCTAssertEqual(Posts.retrieve(Posts.self).count, 1)
            
            done = true
        })

        if(!done){
            XCTFail("Expectation not called!")
        }
    }
    
    func testBadUrl(){
        genericTest("Bad url", type: nil)
    }
    
    func testPosts(){
        genericTest(EndpointType.Posts.path(), type: Posts.self)
    }
}
