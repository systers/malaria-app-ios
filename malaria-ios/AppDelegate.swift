import UIKit

/// AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  let widgetHandler = WidgetHandler.sharedInstance

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    // Do not show widget by default (think about first starting the app and still needing to select the medicine)
    widgetHandler.setVisibility(false)

    // registering for notifications
    var notificationsCategories: [UIMutableUserNotificationCategory] = [UIMutableUserNotificationCategory]()
    notificationsCategories.append(MedicineNotificationsManager.setup())
    let settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: NSSet(array: notificationsCategories) as? Set<UIUserNotificationCategory>)
    application.registerUserNotificationSettings(settings)

    readApplicationSettings()

    // setting up initial screen, can be configured in the storyboard if there is only one option but here we have more flexibility
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.rootViewController = UIStoryboard.instantiate(viewControllerClass: TabbedBarController.self)
    window!.makeKeyAndVisible()

    return true
  }

  func readApplicationSettings() {
    if UserSettingsManager.UserSetting.ClearMedicineHistory.getBool(){
      Logger.Warn("Clearing Medicine History")
      MedicineManager(context: CoreDataHelper.sharedInstance.createBackgroundContext()!).clearCoreData()
      UserSettingsManager.UserSetting.ClearMedicineHistory.setBool(false)
      UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(false)
    }

    if UserSettingsManager.UserSetting.ClearTripHistory.getBool(){
      Logger.Warn("Clearing Trip History")
      TripsManager(context: CoreDataHelper.sharedInstance.createBackgroundContext()!).clearCoreData()
      UserSettingsManager.UserSetting.ClearTripHistory.setBool(false)
    }
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    widgetHandler.handleAppDidResignActive()
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    widgetHandler.handleAppDidBecomeActive()
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> ()) {

    if let category = notification.category{
      switch(category) {
      case MedicineNotificationsManager.NotificationCategory:
        if let id = identifier {
          switch (id) {
          case MedicineNotificationsManager.TookPillId:
            let context = CoreDataHelper.sharedInstance.createBackgroundContext()!
            let currentMedicine = MedicineManager(context: context).getCurrentMedicine()
            currentMedicine?.registriesManager.addRegistry(NSDate(), tookMedicine: true)
            currentMedicine?.notificationManager.reshedule()
          case MedicineNotificationsManager.DidNotTakePillId:
            let context = CoreDataHelper.sharedInstance.createBackgroundContext()!
            let currentMedicine = MedicineManager(context: context).getCurrentMedicine()
            currentMedicine?.registriesManager.addRegistry(NSDate(), tookMedicine: false)

            currentMedicine?.notificationManager.reshedule()
          default:
            Logger.Error("ID not found")
          }
        }
        
      default: Logger.Error("No support for that category")
      }
    }
    completionHandler()
  }
}