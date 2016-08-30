import Foundation
import UIKit

/// NSNotificationCenter wrapper.

class NSNotificationEvents {
  
  /**
   List of events
   
   - dataUpdated: When medicine is changed or if there was a change in the entries.
   - RFGameFinished - A Rapid Fire game finished.
   - MVFGameFinished - A Myth vs. Fact game finished.
   - tripPlanned - A trip was planned.
   - UIApplicationWillEnterForegroundNotification: When application enters foreground.
   - UIApplicationDidBecomeActiveNotification: When application becomes active.
   - UIApplicationWillResignActiveNotification: When application stops being active.
   */
  
  // TODO: Replace `UIApplication` enums with lowercase initials when Swift 3 will require them.
  
  enum Events: String {
    case dataUpdated
    case RFGameFinished
    case MVFGameFinished
    case tripPlanned
    case UIApplicationWillEnterForegroundNotification
    case UIApplicationDidBecomeActiveNotification
    case UIApplicationWillResignActiveNotification
  }
  
  /**
   Observe when the Rapid Fire Game Finished.
   
   - parameter observer: The object that will observe the changes.
   - parameter selector: The selector method that will be triggered.
   */
  
  static func ObserveRFGameFinished(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.RFGameFinished.rawValue, observer, selector)
  }
  
  /**
   Observe when the Myth vs. Fact Game Finished.
   
   - parameter observer: The object that will observe the changes.
   - parameter selector: The selector method that will be triggered.
   */
  
  static func ObserveMVFGameFinished(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.MVFGameFinished.rawValue, observer, selector)
  }
  
  /**
   Observe when a trip was planned.
   
   - parameter observer: The object that will observe the changes.
   - parameter selector: The selector method that will be triggered.
   */
  
  static func ObserveTripPlanned(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.tripPlanned.rawValue, observer, selector)
  }
  
  /**
   Observe entered foreground events.
   
   - parameter observer: The object that will observe the changes.
   - parameter selector: The selector method that will be triggered.
   */
  
  static func ObserveEnteredForeground(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.UIApplicationWillEnterForegroundNotification.rawValue, observer, selector)
  }
  
  /**
   Observe app did become active events.
   
   - parameter observer: The object that will observe the changes.
   - parameter selector: The selector method that will be triggered.
   */
  
  static func ObserveAppBecomeActive(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.UIApplicationDidBecomeActiveNotification.rawValue, observer, selector)
  }
  
  /**
   Observe app did resign active events
   
   - parameter observer: The object that will observe the changes.
   - parameter selector: The selector method that will be triggered.
   */
  
  static func ObserveAppWillResignActive(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.UIApplicationWillResignActiveNotification.rawValue, observer, selector)
  }
  
  /**
   Observe new medicine entries
   
   - parameter observer: The object that will observe the changes.
   - parameter selector: The selector method that will be triggered.
   */
  
  static func ObserveDataUpdated(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.dataUpdated.rawValue, observer, selector)
  }
  
  /**
   Send event saying that the current medicine was changed.
   
   - parameter object: The attached object.
   */
  
  static func dataUpdated(object: AnyObject?) {
    NSNotificationEvents.post(Events.dataUpdated.rawValue, object)
  }
  
  /**
   Send event saying that the Rapid Fire Game has finished.
   
   - parameter userInfo: The attached dictionary with information regarding this event.
   */
  
  static func RFGameFinished(userInfo: [String : RapidFireGame!]) {
    NSNotificationEvents.post(Events.RFGameFinished.rawValue, nil, userInfo)
  }
  
  /**
   Send event saying that the Myth vs. Fact Game has finished.
   
   - parameter userInfo: The attached dictionary with information regarding this event.
   */
  
  static func MVFGameFinished(userInfo: [String : MythVsFactGame!]) {
    NSNotificationEvents.post(Events.MVFGameFinished.rawValue, nil, userInfo)
  }
  
  /// Send event saying that a trip was planned.
  static func tripPlanned() {
    NSNotificationEvents.post(Events.tripPlanned.rawValue, nil)
  }
  
  /**
   Stop observing all notifications.
   
   - parameter observer: The object that was observing changes.
   */
  
  static func UnregisterAll(observer: NSObject) {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
  private static func post(name: String,
                           _ object: AnyObject?,
                             _ userInfo: [NSObject : AnyObject]? = [:]) {
    NSNotificationCenter.defaultCenter().postNotificationName(name,
                                                              object: object,
                                                              userInfo: userInfo)
  }
  
  private static func observe(name: String, _ observer: NSObject, _ selector: Selector) {
    NSNotificationCenter.defaultCenter().addObserver(observer,
                                                     selector: selector,
                                                     name: name,
                                                     object: nil)
  }
}