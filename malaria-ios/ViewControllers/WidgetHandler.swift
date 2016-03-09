//
//  WidgetHandler.swift
//  malaria-ios
//
//  Created by Teodor Ciuraru on 3/6/16.
//  Copyright © 2016 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData
import NotificationCenter

// Class that will handle the user interaction with the widget

public class WidgetHandler : NSObject {

  // Singleton
  public static let sharedInstance = WidgetHandler()

  let widgetController: NCWidgetController = NCWidgetController.widgetController()
  let context = CoreDataHelper.sharedInstance.createBackgroundContext()!

  var currentMedicine: Medicine? {
    return MedicineManager(context: context).getCurrentMedicine()
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
    checkIfWeNeedToShowWidget()
  }

  func checkIfWeNeedToShowWidget() -> Bool {

    // check if entry was updated
    guard let currentMedicine = currentMedicine else {
      return false
    }

    return currentMedicine.registriesManager.allRegistriesInPeriod(NSDate()).entries.count == 0
  }

  func showWidget() {
    widgetController.setHasContent(true, forWidgetWithBundleIdentifier: Constants.Widget.WidgetBundleID)
  }

  func hideWidget() {
    widgetController.setHasContent(false, forWidgetWithBundleIdentifier: Constants.Widget.WidgetBundleID)
  }

  // check is user pressed Did Take Pill in the widget
  func checkIfUserPressedButtonInWidget() -> Bool {

    let didTakePillObject = NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.objectForKey(Constants.Widget.DidTakePillForToday)

    guard let _ = didTakePillObject as? Bool else {
      return false
    }

    return true
  }

  func addAppPillEntry() {

    let didTakePillObject = NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.objectForKey(Constants.Widget.DidTakePillForToday)

    guard let didTakePill = didTakePillObject as? Bool else {
      Logger.Error("Couldn't add pill entry.")
      return
    }

    guard let currentMedicine = currentMedicine else {
      Logger.Error("Couldn't add pill entry.")
      return
    }

    // register the entry from the widget
    currentMedicine.registriesManager.addRegistry(NSDate(), tookMedicine: didTakePill)
    currentMedicine.notificationManager.reshedule()
  }

  // Deletes current day widget entry and waits for the other day
  func deleteCurrentDayData() {
    NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.removeObjectForKey(Constants.Widget.DidTakePillForToday)
  }
}