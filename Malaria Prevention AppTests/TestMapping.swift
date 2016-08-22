import XCTest
import SwiftyJSON
@testable import Malaria_Prevention_App

class TestMapping: XCTestCase {
  let jsonFolder = "ApiExamples"
  
  var endpoints: [String : Endpoint] = [:]
  
  var currentContext: NSManagedObjectContext!
  override func setUp() {
    super.setUp()
    currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    
    endpoints = SyncManager(context: currentContext).endpoints
  }
  
  override func tearDown() {
    for(_, value) in endpoints{
      value.clearFromDatabase(currentContext)
    }
  }
  
  func getJSON(fileName: String) -> JSON{
    let path = NSBundle(forClass: TestMapping.self).pathForResource(fileName, ofType: "json", inDirectory: jsonFolder)
    
    if let jsonData = NSData(contentsOfFile:path!) {
      return JSON(data: jsonData, options: NSJSONReadingOptions.AllowFragments, error: nil)
    }else{
      XCTFail("File \(fileName) not found!")
    }
    
    fatalError("File not found")
  }
  
  func testGenericCollectionPost(posts: [Post]) {
    // Objects retrived may be unsorted.
    var sorted = posts.sort({$0.id < $1.id})
    
    XCTAssertTrue(sorted.count == 2)
    samplePost1Test(sorted[0])
    samplePost2Test(sorted[1])
  }
  
  func samplePost1Test(p1: Post) {
    XCTAssertEqual(p1.owner, 1)
    XCTAssertEqual(p1.title, "title1")
    XCTAssertEqual(p1.post_description, "post1")
    XCTAssertEqual(p1.created_at, "2015-06-07T23:55:16.956057Z")
    XCTAssertEqual(p1.updated_at, "2015-06-07T23:55:16.956098Z")
    XCTAssertEqual(p1.id, 1)
  }
  
  func samplePost2Test(p2: Post) {
    XCTAssertEqual(p2.owner, 2)
    XCTAssertEqual(p2.title, "title2")
    XCTAssertEqual(p2.post_description, "post2")
    XCTAssertEqual(p2.created_at, "2015-06-07T23:55:40.684510Z")
    XCTAssertEqual(p2.updated_at, "2015-06-07T23:55:40.684589Z")
    XCTAssertEqual(p2.id, 2)
  }
  
  func testPosts() {
    if let posts = endpoints[EndpointType.Posts.path()]!
      .retrieveJSONObject(getJSON("posts"), context: self.currentContext) as? Posts {
      var results: [Post] = posts.posts.convertToArray()
      
      // Objects retrived may be unsorted.
      results.sortInPlace({$0.id < $1.id})
      
      XCTAssertTrue(results.count == 2)
      
      samplePost1Test(results[0])
      samplePost2Test(results[1])
      
    } else {
      XCTFail("Parse fail")
    }
  }
}