import Foundation
import CoreData
import NotificationCenter

// Class that will handle the user interaction with the widget
public class WidgetHandler : NSObject {

  // Singleton
  public static let sharedInstance = WidgetHandler()

  let widgetController = NCWidgetController.widgetController()

  var context: NSManagedObjectContext {
    return CoreDataHelper.sharedInstance.createBackgroundContext()!
  }

  var currentMedicine: Medicine? {
    return MedicineManager(context: context).getCurrentMedicine()
  }

  override init() {
    super.init()
    // Needs this observer in order to immediately dismiss the widget after
    // an in-app Yes or No button was pressed. If not used, it will not have time to dismiss the widget
    // the first time the app resigns active
    NSNotificationEvents.ObserveDataUpdated(self, selector: "handleDataUpdated")
  }

  deinit {
    NSNotificationEvents.UnregisterAll(self);
  }

  func handleDataUpdated() {
    setVisibility(false)
  }

  func checkIfWeNeedToShowWidget() -> Bool {
    return (currentMedicine?.registriesManager.allRegistriesInPeriod(NSDate()).entries.count == 0) ?? false;
  }

  func setVisibility(value: Bool) {
    widgetController.setHasContent(value, forWidgetWithBundleIdentifier: Constants.Widget.WidgetBundleID)
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

    setVisibility(checkIfWeNeedToShowWidget())

    if checkIfUserPressedButtonInWidget() {
      addAppPillEntry()

      // prepare the widget for another use
      deleteCurrentDayData()
    }
  }

  func handleAppDidResignActive() {

    guard let _ = currentMedicine else {
      return
    }
    
    setVisibility(checkIfWeNeedToShowWidget())
  }
}