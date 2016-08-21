import UIKit
import XCTest
@testable import Malaria_Prevention_App

class TestUserSettings: XCTestCase {
  
  override func setUp() {
    super.setUp()
    UserSettingsManager.clear()
  }
  
  override func tearDown() {
    super.tearDown()
    UserSettingsManager.clear()
  }
  
  func testGetSet() {
    // Don't forget to reset iOS Simulator.
    XCTAssertFalse(UserSettingsManager.UserSetting.didConfigureMedicine.getBool())
    UserSettingsManager.UserSetting.didConfigureMedicine.setBool(true)
    XCTAssertTrue(UserSettingsManager.UserSetting.didConfigureMedicine.getBool())
    UserSettingsManager.UserSetting.didConfigureMedicine.setBool(false)
    XCTAssertFalse(UserSettingsManager.UserSetting.didConfigureMedicine.getBool())
  }
  
  func testUndefinedValue() {
    XCTAssertEqual(UserSettingsManager.UserSetting.tripReminderOption.getString("Bla"), "Bla")
    XCTAssertTrue(UserSettingsManager.UserSetting.didConfigureMedicine.getBool(true))
  }
}