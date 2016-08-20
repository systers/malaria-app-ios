import Foundation

/// NSUserDefaults Wrapper for widgets.

class WidgetSettingsManager {
  
  /**
   Possible user defined settings
   
   - `remainingPillsMeasuringUnit`: String value that represents user setting their remaining. pill
   - `SetRemainingPills`: String value that represents how the remaining pills are measure
   Weekly or Daily.
   - `didTakePillForToday`: A Bool representing if the user pressed Yes in the widget.
   */
  
  enum WidgetSetting: String {
    
    case remainingPills
    case remainingPillsMeasuringUnit
    case didTakePillForToday
    
    private static let allValues = [remainingPills, remainingPillsMeasuringUnit, didTakePillForToday]
    
    /**
     Sets settings boolean flag to the value given by argument.
     
     - parameter value: The value.
     */
    
    func setBool(value: Bool) {
      NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.setBool(value, forKey: self.rawValue)
    }
    
    /**
     Gets the value of the boolean widget setting, if it exists. Else, returns nil.
     
     - parameter defaultValue: (optional) The default value when the variable isn't set.
     Default is `false`.
     
     - returns: The stored value.
     */
    
    func getBool(defaultValue: Bool = false) -> Bool? {
      if let value = NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.objectForKey(self.rawValue) as? Bool {
        return value
      }
      
      Logger.Warn("\(self.rawValue) isn't set, returning nil")
      
      return nil
    }
    
    /**
     Sets settings Object value of the user setting.
     
     - parameter value: The value.
     */
    
    func setObject(value: NSObject) {
      NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!
        .setObject(value, forKey: self.rawValue)
    }
    
    /** Gets the object value for the key. If it is not set, returns a default value and sets.
     
     - returns: The object.
     */
    
    func getObject() -> NSObject? {
      if let value = NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!
        .objectForKey(self.rawValue) as? NSObject {
        return value
      }
      
      Logger.Warn("\(self.rawValue) isn't set, returning nil")
      
      return nil
    }
    
    /// Clears the key from UserDefaults.
    
    func removeKey() {
      return NSUserDefaults.standardUserDefaults().removeObjectForKey(self.rawValue)
    }
  }
  
  /// Clears all values.
  
  class func clear() {
    WidgetSetting.allValues.foreach({$0.removeKey()})
  }
}