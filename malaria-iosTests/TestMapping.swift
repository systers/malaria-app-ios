import XCTest
import SwiftyJSON

class TestMapping: XCTestCase {
    let jsonFolder = "ApiExamples"
    
    var endpoints: [String : Endpoint] = [
        EndpointType.Api.path() : ApiEndpoint(),
        EndpointType.Posts.path() : PostsEndpoint(),
        EndpointType.Regions.path() : RegionsEndpoint(),
        EndpointType.Volunteer.path() : VolunteersEndpoint(),
        EndpointType.Sectors.path() : SectorsEndpoint(),
        EndpointType.Projects.path() : ProjectsEndpoint(),
        EndpointType.Ptposts.path() : PtPostsEndpoint(),
        EndpointType.Goals.path() : GoalsEndpoint(),
        EndpointType.Indicators.path() : IndicatorsEndpoint(),
        EndpointType.Activity.path() : ActivitiesEndpoint(),
        EndpointType.Cohort.path() : CohortsEndpoint(),
        EndpointType.Outcomes.path() : OutcomesEndpoint(),
        EndpointType.Objectives.path() : ObjectivesEndpoint(),
        EndpointType.Measurement.path() : MeasurementsEndpoint(),
        EndpointType.Revposts.path() : RevPostsEndpoint(),
        EndpointType.Outputs.path() : OutputsEndpoint()
    ]
    
    override func tearDown() {
        for(key, value) in endpoints{
            value.clearFromDatabase()
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
    
    func testGenericCollectionPost(posts: [Post]){
        //objects retrived may be unsorted
        var sorted = posts.sorted({$0.id < $1.id})
        
        XCTAssertTrue(sorted.count == 2)
        samplePost1Test(sorted[0])
        samplePost2Test(sorted[1])
    }
    
    func samplePost1Test(p1: Post){
        XCTAssertEqual(p1.owner, 1)
        XCTAssertEqual(p1.title, "title1")
        XCTAssertEqual(p1.post_description, "post1")
        XCTAssertEqual(p1.created_at, "2015-06-07T23:55:16.956057Z")
        XCTAssertEqual(p1.updated_at, "2015-06-07T23:55:16.956098Z")
        XCTAssertEqual(p1.id, 1)
    }
    
    func samplePost2Test(p2: Post){
        XCTAssertEqual(p2.owner, 2)
        XCTAssertEqual(p2.title, "title2")
        XCTAssertEqual(p2.post_description, "post2")
        XCTAssertEqual(p2.created_at, "2015-06-07T23:55:40.684510Z")
        XCTAssertEqual(p2.updated_at, "2015-06-07T23:55:40.684589Z")
        XCTAssertEqual(p2.id, 2)
    }
    
    func testApi(){
        if let api = endpoints[EndpointType.Api.path()]!.retrieveJSONObject(getJSON("api")) as? Api{
            XCTAssertEqual(api.users, "url1")
            XCTAssertEqual(api.posts, "url2")
            XCTAssertEqual(api.revposts, "url3")
            XCTAssertEqual(api.regions, "url4")
            XCTAssertEqual(api.sectors, "url5")
            XCTAssertEqual(api.ptposts, "url6")
            XCTAssertEqual(api.projects, "url7")
            XCTAssertEqual(api.goals, "url8")
            XCTAssertEqual(api.objectives, "url9")
            XCTAssertEqual(api.indicators, "url10")
            XCTAssertEqual(api.outputs, "url11")
            XCTAssertEqual(api.outcomes, "url12")
            XCTAssertEqual(api.activity, "url13")
            XCTAssertEqual(api.measurement, "url14")
            XCTAssertEqual(api.cohort, "url15")
            XCTAssertEqual(api.volunteer, "url16")
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testPosts(){
        if let posts = endpoints[EndpointType.Posts.path()]!.retrieveJSONObject(getJSON("posts")) as? Posts{
            var results: [Post] = posts.posts.convertToArray()
            
            //objects retrived may be unsorted
            results.sort({$0.id < $1.id})
            
            XCTAssertTrue(results.count == 2)
            
            samplePost1Test(results[0])
            samplePost2Test(results[1])
            
        }else{
            XCTFail("Parse fail")
        }
        
    }

    
    func testRevPosts(){
        if let revposts = endpoints[EndpointType.Revposts.path()]!.retrieveJSONObject(getJSON("revposts")) as? RevPosts{
            var results: [RevPost] = revposts.rev_posts.convertToArray()
            
            //objects retrived may be unsorted
            results.sort({$0.id < $1.id})
            
            XCTAssertTrue(results.count == 1)
            
            let p1 = results[0]
            XCTAssertEqual(p1.owner_post, 1)
            XCTAssertEqual(p1.owner, 3)
            XCTAssertEqual(p1.title, "title1")
            XCTAssertEqual(p1.post_description, "posted1")
            XCTAssertEqual(p1.created_at, "createdString")
            XCTAssertEqual(p1.id, 1)
            XCTAssertEqual(p1.title_change, false)
            XCTAssertEqual(p1.description_change, true)
        }else{
            XCTFail("Parse fail")
        }
        
    }
    
    func testRegions(){
        if let regions = endpoints[EndpointType.Regions.path()]!.retrieveJSONObject(getJSON("regions")) as? Regions{
            testGenericCollectionPost(regions.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testSectors(){
        if let sectors = endpoints[EndpointType.Sectors.path()]!.retrieveJSONObject(getJSON("sectors")) as? Sectors{
            let array: [Sector] = sectors.sectors.convertToArray()
            
            XCTAssertEqual(array.count, 1)
            
            let sector = array[0]
            XCTAssertEqual(sector.name, "Community Economic Development")
            XCTAssertEqual(sector.desc, "Working towards that")
            XCTAssertEqual(sector.code, "CED")
            XCTAssertEqual(sector.id, 1)
            
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testPtPosts(){
        if let ptPosts = endpoints[EndpointType.Ptposts.path()]!.retrieveJSONObject(getJSON("ptposts")) as? PtPosts{
            testGenericCollectionPost(ptPosts.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testProjects(){
        if let projects = endpoints[EndpointType.Projects.path()]!.retrieveJSONObject(getJSON("projects")) as? Projects{
            testGenericCollectionPost(projects.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testVolunteers(){
        if let volunteers = endpoints[EndpointType.Volunteer.path()]!.retrieveJSONObject(getJSON("volunteer")) as? Volunteers{
            testGenericCollectionPost(volunteers.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testCohort(){
        if let cohorts = endpoints[EndpointType.Cohort.path()]!.retrieveJSONObject(getJSON("cohort")) as? Cohorts{
            testGenericCollectionPost(cohorts.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testMeasurements(){
        if let measurements = endpoints[EndpointType.Measurement.path()]!.retrieveJSONObject(getJSON("measurement")) as? Measurements{
            testGenericCollectionPost(measurements.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testActivity(){
        if let activities = endpoints[EndpointType.Activity.path()]!.retrieveJSONObject(getJSON("activity")) as? Activities{
            testGenericCollectionPost(activities.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testOutcomes(){
        if let outcomes = endpoints[EndpointType.Outcomes.path()]!.retrieveJSONObject(getJSON("outcomes")) as? Outcomes{
            testGenericCollectionPost(outcomes.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testOutputs(){
        if let outputs = endpoints[EndpointType.Outputs.path()]!.retrieveJSONObject(getJSON("outputs")) as? Outputs{
            testGenericCollectionPost(outputs.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testIndicators(){
        if let indicators = endpoints[EndpointType.Indicators.path()]!.retrieveJSONObject(getJSON("indicators")) as? Indicators{
            testGenericCollectionPost(indicators.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testObjectives(){
        if let objectives = endpoints[EndpointType.Objectives.path()]!.retrieveJSONObject(getJSON("objectives")) as? Objectives{
            testGenericCollectionPost(objectives.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
    func testGoals(){
        if let goals = endpoints[EndpointType.Goals.path()]!.retrieveJSONObject(getJSON("goals")) as? Goals{
            testGenericCollectionPost(goals.posts.convertToArray())
        }else{
            XCTFail("Parse fail")
        }
    }
    
}
