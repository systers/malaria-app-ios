import Foundation

/// NSUserDefaults Wrapper.

class UserSettingsManager {
  
  /**
   Possible user defined settings.
   
   - `didConfigureMedicine`: Boolean that represents there is a default pill
   - `clearTripHistory`: Boolean toggled in the settings that clears trip history on launch
   - `clearMedicineHistory`: Boolean toggled in the settings that clears medicine history on launch
   - `medicineReminderSwitch`: Boolean toggled in the settings that allows turning on and off the reminders
   - `tripReminderOption`: String value that represents notification settings for trip
   - `pillReminderValue`: String value that represents the interval to be reminder for the pill
   - `saveLocalNotificaions`: String value that represents notification array store persisently.
   */
  
  enum UserSetting: String {
    private static let allValues = [didConfigureMedicine,
                                    clearTripHistory,
                                    clearMedicineHistory,
                                    medicineReminderSwitch,
                                    tripReminderOption,
                                    pillReminderValue,
                                    saveLocalNotifications]
    
    case didConfigureMedicine
    case clearTripHistory
    case clearMedicineHistory
    case medicineReminderSwitch
    case tripReminderOption
    case pillReminderValue
    case saveLocalNotifications
    
    /**
     Sets settings boolean flag to the value given by argument.
     
     - parameter value: The new value.
     */
    
    func setBool(value: Bool) {
      NSUserDefaults.standardUserDefaults().setBool(value, forKey: self.rawValue)
    }
    
    /**
     Gets the value of the boolean user setting. If the value isn't set, sets it as default value and returns.
     
     - parameter defaultValue: (optional) Default value when the variable isn't set.
     `false` by default.
     
     - returns: The value that was stored.
     */
    
    func getBool(defaultValue: Bool = false) -> Bool {
      if let value = NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) as? Bool {
        return value
      }
      
      Logger.Warn("\(self.rawValue) isn't set, setting and returning default value \(defaultValue)")
      
      self.setBool(defaultValue)
      return defaultValue
    }
    
    /**
     Sets settings String value of the user setting.
     
     - parameter value: The value to be stored.
     */
    
    func setString(value: String) {
      NSUserDefaults.standardUserDefaults().setObject(value, forKey: self.rawValue)
    }
    
    /**
     Gets the string value for the key. If it is not set, returns a default value and sets
     
     - parameter defaultValue: (optional) Default value when the variable isn't set.
     Empty string by default.
     
     - returns: The value that was stored.
     */
    
    func getString(defaultValue: String = "") -> String {
      if let value = NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) as? String {
        return value
      }
      
      Logger.Warn("\(self.rawValue) isn't set, setting and returning default value \(defaultValue)")
      
      self.setString(defaultValue)
      return defaultValue
    }
    
    /**
     Sets settings local notifications data in the user setting.
     
     - parameter value: Local notifications array.
     */
    
    func setLocalNotifications(value: NSData) {
      NSUserDefaults.standardUserDefaults().setObject(value, forKey: self.rawValue)
    }
    
    /**
     Gets the local notifications data for the key. If it is not set, returns the default value.
     - parameter defaultValue: (optional) Default value when the variable isn't set.
     Empty string by default.
     
     - returns: The value we get from `NSUserDefaults`.
     */
    
    func getLocalNotifications(defaultValue: NSData = NSData()) -> NSData? {
      if let value = NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) {
        return value as? NSData
      }
      
      Logger.Warn("\(self.rawValue) isn't set, setting and returning default value \(defaultValue)")
      
      self.setLocalNotifications(defaultValue)
      return defaultValue
    }
    
    /// Clears the key from UserDefaults.
    
    func removeKey() {
      return NSUserDefaults.standardUserDefaults().removeObjectForKey(self.rawValue)
    }
  }
  
  /// Syncronize standardUserDefaults.
  
  class func syncronize() {
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  /// Clears all values.
  
  class func clear() {
    UserSetting.allValues.foreach({$0.removeKey()})
  }
}