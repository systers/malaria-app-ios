import Foundation

/// NSUserDefaults Wrapper for widgets.

class WidgetSettingsManager {
  
  /**
   Possible user defined settings
   
   - `RemainingPillsMeasuringUnit`: String value that represents user setting their remaining. pill
   - `SetRemainingPills`: String value that represents how the remaining pills are measure
   Weekly or Daily.
   - `DidTakePillForToday`: A Bool representing if the user pressed Yes in the widget.
   */
  
  enum WidgetSetting: String {
    
    case RemainingPills
    case RemainingPillsMeasuringUnit
    case DidTakePillForToday
    
    private static let allValues = [RemainingPills, RemainingPillsMeasuringUnit, DidTakePillForToday]
    
    /**
     Sets settings boolean flag to the value given by argument.
     
     - parameter `Bool`:
     */
    
    func setBool(value: Bool){
      NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!.setBool(value, forKey: self.rawValue)
    }
    
    /**
     Gets the value of the boolean widget setting, if it exists. Else, returns nil.
     
     - parameter `Bool: optional`: default value when the variable isn't set. Default False.
     
     - returns: `Bool`: The value.
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
     
     - parameter `Object`:: value.
     */
    
    func setObject(value: NSObject) {
      NSUserDefaults(suiteName: Constants.Widget.AppGroupBundleID)!
        .setObject(value, forKey: self.rawValue)
    }
    
    /** Gets the object value for the key. If it is not set, returns a default value and sets.
     
     - parameter `Object: optional`: default value when the variable isn't set. Default empty string.
     
     - returns: `Object`:  The value.
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