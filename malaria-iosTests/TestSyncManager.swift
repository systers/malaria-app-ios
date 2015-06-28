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
            
            XCTAssertEqual(Api.retrieve(Api.self).count, 1)
            XCTAssertEqual(Posts.retrieve(Posts.self).count, 1)
            XCTAssertEqual(RevPosts.retrieve(RevPosts.self).count, 1)
            XCTAssertEqual(Regions.retrieve(Regions.self).count, 1)
            XCTAssertEqual(Sectors.retrieve(Sectors.self).count, 1)
            XCTAssertEqual(PtPosts.retrieve(PtPosts.self).count, 1)
            XCTAssertEqual(Projects.retrieve(Projects.self).count, 1)
            XCTAssertEqual(Cohorts.retrieve(Cohorts.self).count, 1)
            XCTAssertEqual(Measurements.retrieve(Measurements.self).count, 1)
            XCTAssertEqual(Activities.retrieve(Activities.self).count, 1)
            XCTAssertEqual(Outcomes.retrieve(Outcomes.self).count, 1)
            XCTAssertEqual(Outputs.retrieve(Outputs.self).count, 1)
            XCTAssertEqual(Indicators.retrieve(Indicators.self).count, 1)
            XCTAssertEqual(Objectives.retrieve(Objectives.self).count, 1)
            XCTAssertEqual(Goals.retrieve(Goals.self).count, 1)
            
            done = true
        })

        if(!done){
            XCTFail("Expectation not called!")
        }
    }
    
    func testBadUrl(){
        genericTest("Bad url", type: nil)
    }
    
    func testApi(){
        genericTest(EndpointType.Api.path(), type: Api.self)
    }
    
    func testPosts(){
        genericTest(EndpointType.Posts.path(), type: Posts.self)
    }
    
    func testRevPosts(){
        genericTest(EndpointType.Revposts.path(), type: RevPosts.self)
    }
    
    func testRegions(){
        genericTest(EndpointType.Regions.path(), type: Regions.self)
    }
    
    func testSectors(){
        genericTest(EndpointType.Sectors.path(), type: Sectors.self)
    }
    
    func testPtPosts(){
        genericTest(EndpointType.Ptposts.path(), type: PtPosts.self)
    }
    
    func testProjects(){
        genericTest(EndpointType.Projects.path(), type: Projects.self)
    }
    
    func testVolunteer(){
        genericTest(EndpointType.Volunteer.path(), type: Volunteers.self)
    }
    
    func testCohort(){
        genericTest(EndpointType.Cohort.path(), type: Cohorts.self)
    }
    
    func testMeasurement(){
        genericTest(EndpointType.Measurement.path(), type: Measurements.self)
    }
    
    func testActivity(){
        genericTest(EndpointType.Activity.path(), type: Activities.self)
    }
    
    func testOutcomes(){
        genericTest(EndpointType.Outcomes.path(), type: Outcomes.self)
    }
    
    func testOutputs(){
        genericTest(EndpointType.Outputs.path(), type: Outputs.self)
    }
    
    func testIndicators(){
        genericTest(EndpointType.Indicators.path(), type: Indicators.self)
    }
    
    func testObjectives(){
        genericTest(EndpointType.Objectives.path(), type: Objectives.self)
    }
    
    func testGoals(){
        genericTest(EndpointType.Goals.path(), type: Goals.self)
    }
}
