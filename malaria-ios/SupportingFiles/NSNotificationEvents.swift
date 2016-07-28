import Foundation
import UIKit

/// NSNotificationCenter wrapper
class NSNotificationEvents {
  
  /// List of events
  ///
  /// - DataUpdated: When medicine is changed or if there was a change in the entries
  /// - UIApplicationWillEnterForegroundNotification: When application enters foreground
  /// - UIApplicationDidBecomeActiveNotification: When application becomes active
  /// - UIApplicationWillResignActiveNotification: When application stops being active
  enum Events : String {
    case DataUpdated
    case RFGameFinished
    case MVFGameFinished
    case TripPlanned
    case UIApplicationWillEnterForegroundNotification
    case UIApplicationDidBecomeActiveNotification
    case UIApplicationWillResignActiveNotification
  }
  
  /// Observe when the Rapid Fire Game Finished
  ///
  /// - parameter `NSObject`:: intended object
  /// - parameter `Selector`:: NSObject selector
  static func ObserveRFGameFinished(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.RFGameFinished.rawValue, observer, selector)
  }
  
  /// Observe when the Myth vs. Fact Game Finished
  ///
  /// - parameter `NSObject`:: intended object
  /// - parameter `Selector`:: NSObject selector
  static func ObserveMVFGameFinished(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.MVFGameFinished.rawValue, observer, selector)
  }
  
  /// Observe when a trip was planned.
  ///
  /// - parameter `NSObject`:: intended object
  /// - parameter `Selector`:: NSObject selector
  static func ObserveTripPlanned(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.TripPlanned.rawValue, observer, selector)
  }
  
  /// Observe entered foreground events
  ///
  /// - parameter `NSObject`:: intended object
  /// - parameter `Selector`:: NSObject selector
  static func ObserveEnteredForeground(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.UIApplicationWillEnterForegroundNotification.rawValue, observer, selector)
  }
  
  /// Observe app did become active events
  ///
  /// - parameter `NSObject`:: intended object
  /// - parameter `Selector`:: NSObject selector
  static func ObserveAppBecomeActive(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.UIApplicationDidBecomeActiveNotification.rawValue, observer, selector)
  }
  
  /// Observe app did resign active events
  ///
  /// - parameter `NSObject`:: intended object
  /// - parameter `Selector`:: NSObject selector
  static func ObserveAppWillResignActive(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.UIApplicationWillResignActiveNotification.rawValue, observer, selector)
  }
  
  /// Observe new medicine entries
  ///
  /// - parameter `NSObject`:: intended object
  /// - parameter `Selector`:: NSObject selector
  static func ObserveDataUpdated(observer: NSObject, selector: Selector) {
    NSNotificationEvents.observe(Events.DataUpdated.rawValue, observer, selector)
  }
  
  /// Send event saying that the current medicine was changed
  ///
  /// - parameter `AnyObject?`:: attached object
  static func DataUpdated(object: AnyObject?) {
    NSNotificationEvents.post(Events.DataUpdated.rawValue, object)
  }
  
  /// Send event saying that the Rapid Fire Game has finished.
  static func RFGameFinished(userInfo: [String : RapidFireGame!]) {
    NSNotificationEvents.post(Events.RFGameFinished.rawValue, nil, userInfo)
  }
  
  /// Send event saying that the Myth vs. Fact Game has finished.
  static func MVFGameFinished(userInfo: [String : MythVsFactGame!]) {
    NSNotificationEvents.post(Events.MVFGameFinished.rawValue, nil, userInfo)
  }
  
  /// Send event saying that a trip was.
  static func TripPlanned() {
    NSNotificationEvents.post(Events.TripPlanned.rawValue, nil)
  }
  
  /// Stop observing all notifications
  ///
  /// - parameter `NSObject`:: intended object
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