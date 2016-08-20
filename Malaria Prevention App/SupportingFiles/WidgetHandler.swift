//
//  WidgetHandler.swift
//
//  Created by Teodor Ciuraru on 3/6/16.
//

import Foundation
import CoreData
import NotificationCenter

// Class that will handle the user interaction with the widget
public class WidgetHandler : NSObject {

  // Singleton
  public static let sharedInstance = WidgetHandler()

  let widgetController: NCWidgetController = NCWidgetController.widgetController()

  var context: NSManagedObjectContext? {
    return CoreDataHelper.sharedInstance.createBackgroundContext()!
  }

  var currentMedicine: Medicine? {
    return MedicineManager(context: context!).getCurrentMedicine()
  }

  override init() {
    super.init()
    NSNotificationEvents.ObserveDataUpdated(self, selector: "dataSaved:")
  }

  deinit {
    NSNotificationEvents.UnregisterAll(self);
  }

  func dataSaved(notification: NSNotification) {
    Logger.Info("Data updated")
    checkUserInputForToday()
  }

  func checkUserInputForToday() -> Bool {
    // check if entry was updated
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
}