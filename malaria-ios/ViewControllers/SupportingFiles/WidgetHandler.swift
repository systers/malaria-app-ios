import Foundation
import CoreData
import NotificationCenter

// Class that will handle the user interaction with the widget
public class WidgetHandler : NSObject {

  // Singleton
  public static let sharedInstance = WidgetHandler()

  let widgetController = NCWidgetController.widgetController()

  var _currentContext: NSManagedObjectContext!
  var currentContext: NSManagedObjectContext! {
    get {
      _currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
      return _currentContext
    }
  }

  var currentMedicine: Medicine? {
    return MedicineManager(context: currentContext).getCurrentMedicine()
  }

  override init() {
    super.init()
    // Needs this observer in order to immediately dismiss the widget after
    // an in-app Yes or No button was pressed. If not used, it will not have time to dismiss the widget
    // the first time the app resigns active
    NSNotificationEvents.ObserveDataUpdated(self, selector: #selector(handleDataUpdated))
    NSNotificationEvents.ObserveAppWillResignActive(self, selector: #selector(handleAppWillResignActive))
    NSNotificationEvents.ObserveAppBecomeActive(self, selector: #selector(handleAppDidBecomeActive))
  }

  deinit {
    NSNotificationEvents.UnregisterAll(self);
  }

  func handleDataUpdated() {
    setVisibility(checkIfUserPressedButtonInWidget())
  }


  func UserProvidedFeedbackForToday() -> Bool {
    return (currentMedicine?.registriesManager.allRegistriesInPeriod(NSDate()).entries.count == 0) ?? false;
  }

  func setVisibility(value: Bool) {
    widgetController.setHasContent(value, forWidgetWithBundleIdentifier: Constants.Widget.BundleID)
  }

  // check is user pressed Did Take Pill in the widget
  func checkIfUserPressedButtonInWidget() -> Bool {
    return NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.objectForKey(Constants.Widget.DidTakePillForToday) != nil
  }

  func addAppPillEntry() {
    let didTakePillObject = NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.objectForKey(Constants.Widget.DidTakePillForToday)

    if let didTakePill = didTakePillObject as? Bool,
      currentMedicine = currentMedicine {

        // register the entry from the widget
        currentMedicine.registriesManager.addRegistry(NSDate(), tookMedicine: didTakePill)
        currentMedicine.notificationManager.reshedule()
    }
  }

  // Deletes current day widget entry and waits for the other day
  func deleteCurrentDayData() {
    NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.removeObjectForKey(Constants.Widget.DidTakePillForToday)
  }

  func handleAppDidBecomeActive() {
    guard let _ = currentMedicine else {
      return
    }

    setVisibility(UserProvidedFeedbackForToday())

    if checkIfUserPressedButtonInWidget() {
      addAppPillEntry()

      // prepare the widget for another use
      deleteCurrentDayData()
    }
  }

  func handleAppWillResignActive() {
    guard let _ = currentMedicine else {
      return
    }
    
    setVisibility(UserProvidedFeedbackForToday())
  }
}