import UIKit
import XCTest

class TestRestMappers: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let testTargetBundle = NSBundle(identifier: "anita-borg.malaria-iosTests")
        RKTestFixture.setFixtureBundle(testTargetBundle)
    }
    
    func createMappingDirectAttributeMapTest(mapping: RKEntityMapping, sourceJson: String, attrs: [String]) -> RKMappingTest{
        let parsedJson: AnyObject? = RKTestFixture.parsedObjectWithContentsOfFixture(sourceJson)
        
        let test = RKMappingTest(forMapping: mapping, sourceObject: parsedJson, destinationObject: nil)
        test.managedObjectContext = CoreDataHelper.sharedInstance.backgroundContext
        
        attrs.map({test.addExpectation(RKPropertyMappingTestExpectation(sourceKeyPath: $0, destinationKeyPath: $0))})
        
        return test
    }
    
    
    func testApiEndpointMapper() {
        
        let attributes = [
            "users",
            "posts",
            "revposts",
            "regions" ,
            "sectors",
            "ptposts",
            "projects",
            "goals",
            "objectives",
            "indicators",
            "outputs",
            "outcomes",
            "activity",
            "measurement",
            "cohort",
            "volunteer"
        ]
        let test = createMappingDirectAttributeMapTest(ApiEndpoint().mapping, sourceJson: "api.json", attrs: attributes)
        
        XCTAssertTrue(test.evaluate)
    }
    
    
    //https://stackoverflow.com/questions/25307039/restkit-how-can-i-test-nested-relationship-data-by-fixture
    func testPostsEndpointMapper(){
        
        //define mapping
        let postMapping = RKEntityMapping.mapAtributesAndRelationships("Post", attributes: ["created" : "created_at"], relationships: [:])
        let entityMapping = RKEntityMapping.mapAtributesAndRelationships("CollectionPosts", attributes: [:], relationships: ["result" : postMapping])
        
        //create expectations
        let parsedJson: AnyObject? = RKTestFixture.parsedObjectWithContentsOfFixture("posts.json")
        let mappingTest = RKMappingTest(mapping: entityMapping, sourceObject: parsedJson, destinationObject: nil)
        mappingTest.managedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!
        
        
       
        /// Configure expectation objects
        let post = Post.create(Post.self)
        post.owner = 1
        post.title = "title1"
        post.post_description = "post1"
        post.created_at = "2015-06-07T23:55:16.956057Z"
        post.updated_at = "2015-06-07T23:55:16.956098Z"
        post.id = 1
        
        let post2 = Post.create(Post.self)
        post2.owner = 2
        post2.title = "title2"
        post2.post_description = "post2"
        post2.created_at = "2015-06-07T23:55:40.684510Z"
        post2.updated_at = "2015-06-07T23:55:40.684589Z"
        post2.id = 2
        
        let set = NSOrderedSet(array: [post, post2])
        
        let expectation1 = RKPropertyMappingTestExpectation(sourceKeyPath: "results", destinationKeyPath: "results")
        mappingTest.addExpectation(expectation1)
        mappingTest.verify()

        
        
        /*
        RKManagedObjectStore *managedObjectStore = [RKTestFactory managedObjectStore];
        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Article" inManagedObjectStore:managedObjectStore];
        entityMapping.identificationAttributes = @[ @"articleID" ];
        [entityMapping addAttributeMappingsFromDictionary:@{
        @"id":              @"articleID",
        @"title":           @"title",
        @"category_ids":    @"categoryIDs"
        }];
        
        // Add a connection from our Article's list of `categoryIDs` to all Category objects with a matching `categoryID`
        [entityMapping addConnectionForRelationship:@"categories" connectedBy:@{ @"categoryIDs": @"categoryID" }];
        
        
        
        NSDictionary *articleRepresentation = @{ @"id": @(1234), @"title": @"The Title", @"category_ids": @[ @(1), @(2), @(3), @(4) ] };
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:entityMapping sourceObject:articleRepresentation destinationObject:nil];
        
        DONE
        
        

        
        // Configure Core Data
        mappingTest.managedObjectContext = managedObjectStore.persistentStoreManagedObjectContext;
        
        // Create Category objects to match our criteria
        NSManagedObject *category_1 = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
        [category_1 setValue:@(1) forKey:@"categoryID"];
        [category_1 setValue:@"Hacking" forKey:@"title"];
        
        NSManagedObject *category_2 = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
        [category_2 setValue:@(2) forKey:@"categoryID"];
        [category_2 setValue:@"Objective-C" forKey:@"title"];
        
        NSManagedObject *category_3 = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
        [category_3 setValue:@(3) forKey:@"categoryID"];
        [category_3 setValue:@"RestKit" forKey:@"title"];
        
        NSManagedObject *category_4 = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
        [category_4 setValue:@(4) forKey:@"categoryID"];
        [category_4 setValue:@"Cocoa" forKey:@"title"];
        
        // Configure an expectation for our connection
        [mappingTest addExpectation:[RKConnectionTestExpectation expectationWithRelationshipName:@"categories" attributes:@{ @"categoryIDs": @"categoryID" } value:[NSSet setWithObjects:category_1, category_2, category_3, category_4, nil]]];
        
        BOOL success = [mappingTest evaluate];
        STAssertTrue(success, @"Expected connection to be satisfied, but was not.") */
        
    }
}