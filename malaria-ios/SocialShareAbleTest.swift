import XCTest
@testable import malaria_ios

class SocialShareAbleTest: XCTestCase {
    
    var viewController: SocialMediaController!

    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testControllerPresentsSocialMedia() {
        struct fakeSocialItem: SocialShareable {
            var message = "Fake message"
        
        }
        class fakeSocialMediaController: SocialMediaController {
            var shared = false
            var socialItem = fakeSocialItem()
            func share(socialItem: SocialShareable, toMedia: SocialMediaType, withMessage: String) {
                shared = true
            }
        }
        
        
        
        let socialMediaController = fakeSocialMediaController()
        let socialItem = socialMediaController.socialItem
        socialMediaController.share(socialItem, toMedia: .Facebook, withMessage: "Test Message")
        
        XCTAssert(socialMediaController.shared)
    }
}
