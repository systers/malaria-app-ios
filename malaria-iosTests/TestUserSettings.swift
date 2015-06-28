import UIKit
import XCTest

class TestUserSettings: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserSettingsManager.clear()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetSet() {
        //dont forget to reset iOS Simulator
        XCTAssertEqual(false, UserSettingsManager.getBool(UserSetting.DidConfiguredMedicine))
        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicine, true)
        XCTAssertEqual(true, UserSettingsManager.getBool(UserSetting.DidConfiguredMedicine))
        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicine, false)
        XCTAssertEqual(false, UserSettingsManager.getBool(UserSetting.DidConfiguredMedicine))
    }
}
