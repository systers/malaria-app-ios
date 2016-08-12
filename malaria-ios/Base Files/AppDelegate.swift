import UIKit
import GoogleMaps
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  let widgetHandler = WidgetHandler.sharedInstance
  
  let generalAchievementManager = GeneralAchievementsManager.sharedInstance
  let rapidFireAchievementManager = RapidFireAchievementManager.sharedInstance
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // Fabric's Crashlytics initialization
    Fabric.with([Crashlytics.self])
    
    // API Key For GoogleMaps
    GMSServices.provideAPIKey("AIzaSyBgUKTQgo0v5dCz-qzHbbDL3dvatlyx8E8")
    
    // Do not show widget by default (first starting the app and still needing to select the medicine)
    widgetHandler.setVisibility(false)
    
    // registering for notifications
    var notificationsCategories: [UIMutableUserNotificationCategory] = [UIMutableUserNotificationCategory]()
    notificationsCategories.append(MedicineNotificationsManager.setup())
    let settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: NSSet(array: notificationsCategories) as? Set<UIUserNotificationCategory>)
    application.registerUserNotificationSettings(settings)
    
    readApplicationSettings()
    
    // setting up initial screen, can be configured in the storyboard if there is only one option but here we have more flexibility
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.rootViewController = UIStoryboard.instantiate(TabbedBarController.self)
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
  
  /**
   A method which presents the setup screen, used when the Gear button is pressed.
   
   - parameter delegate: A ViewController that implements
   the `PresentsModalityDelegate` delegate.
   */
  
  func presentSetupScreen(withDelegate delegate: PresentsModalityDelegate) {
    
    // `dispatch_async` fixes the view controller presentation delay.
    dispatch_async(dispatch_get_main_queue()) {
      let view = UIStoryboard.instantiate(SetupScreenViewController.self) as SetupScreenViewController
      
      view.delegate = delegate
      
      /*
       We can make this cast because only ViewControllers will implement the
       PresentsModalityDelegate in this app.
       
       i.e PresentsModalityDelegate and ViewController are interchangable.
       */
      
      let viewController = delegate as! UIViewController
      viewController.presentViewController(view, animated: true, completion: nil)
    }
  }
  
  /**
   A method which presents the setup screen on the first run of the app.
   
   - parameter delegate: A ViewController that implements
   the `PresentsModalityDelegate` delegate.
   */
  
  func presentInitialSetupScreen(withDelegate delegate: PresentsModalityDelegate) {
    
    // `dispatch_async` fixes the view controller presentation delay.
    dispatch_async(dispatch_get_main_queue()) {
      let view = UIStoryboard.instantiate(SetupScreenUserProfileViewController.self) as SetupScreenUserProfileViewController
      
      view.delegate = delegate
      
      /*
       We can make this cast because only ViewControllers will implement the
       PresentsModalityDelegate in this app.
       
       i.e PresentsModalityDelegate and ViewController are interchangable.
       */
      
      let viewController = delegate as! UIViewController
      viewController.presentViewController(view, animated: true, completion: nil)
    }
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
            currentMedicine?.medicineStockManager.addRegistry(NSDate(), tookMedicine: true)
            currentMedicine?.notificationManager.reshedule()
          case MedicineNotificationsManager.DidNotTakePillId:
            let context = CoreDataHelper.sharedInstance.createBackgroundContext()!
            let currentMedicine = MedicineManager(context: context).getCurrentMedicine()
            currentMedicine?.medicineStockManager.addRegistry(NSDate(), tookMedicine: false)
            
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