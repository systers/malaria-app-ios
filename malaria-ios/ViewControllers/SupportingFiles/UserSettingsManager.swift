import Foundation

/// NSUserDefaults Wrapper.

class UserSettingsManager {
  
  /**
   Possible user defined settings
   
   - `DidConfiguredMedicine`: Boolean that represents there is a default pill
   - `ClearTripHistory`: Boolean toggled in the settings that clears trip history on launch
   - `ClearMedicineHistory`: Boolean toggled in the settings that clears medicine history on launch
   - `MedicineReminderSwitch`: Boolean toggled in the settings that allows turning on and off the reminders
   - `TripReminderOption`: String value that represents notification settings for trip
   */
  
  enum UserSetting: String {
    private static let allValues = [DidConfiguredMedicine, ClearTripHistory, ClearMedicineHistory, MedicineReminderSwitch, TripReminderOption, PillReminderValue, SaveLocalNotifications]
    
    case DidConfiguredMedicine
    case ClearTripHistory
    case ClearMedicineHistory
    case MedicineReminderSwitch
    case TripReminderOption
    case PillReminderValue
    case SaveLocalNotifications
    
    /**
     Sets settings boolean flag to the value given by argument
     
     - parameter `Bool`:
     */
    
    func setBool(value: Bool){
      NSUserDefaults.standardUserDefaults().setBool(value, forKey: self.rawValue)
    }
    
    /**
     Gets the value of the boolean user setting. If the value isn't set, sets it as default value and returns
     
     - parameter `Bool: optional`: default value when the variable isn't set. Default false
     
     - returns: `Bool`: The value
     */
    
    func getBool(defaultValue: Bool = false) -> Bool{
      if let value = NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) as? Bool{
        return value
      }
      
      Logger.Warn("\(self.rawValue) isn't set, setting and returning default value \(defaultValue)")
      
      self.setBool(defaultValue)
      return defaultValue
    }
    
    /**
     Sets settings String value of the user setting
     
     - parameter `String`:: value
     */
    
    func setString(value: String){
      NSUserDefaults.standardUserDefaults().setObject(value, forKey: self.rawValue)
    }
    
    /**
     Gets the string value for the key. If it is not set, returns a default value and sets
     
     - parameter `String: optional`: default value when the variable isn't set. Default empty string
     
     - returns: `String`:  The value
     */
    
    func getString(defaultValue: String = "") -> String{
      if let value = NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) as? String {
        return value
      }
      
      Logger.Warn("\(self.rawValue) isn't set, setting and returning default value \(defaultValue)")
      
      self.setString(defaultValue)
      return defaultValue
    }
    
    /**
     Sets settings local notifications data in the user setting.
     
     - parameter `NSData`:: local notifications array.
     */
    
    func setLocalNotifications(value: NSData) {
      NSUserDefaults.standardUserDefaults().setObject(value, forKey: self.rawValue)
    }
    
    /**
     Gets the local notifications data for the key. If it is not set, returns the default value.
     - parameter `String: optional`: default value when the variable isn't set, currently, empty data.
     
     - returns: `NSData?`:  The value we get from NSUserDefaults.
     */
    
    func getLocalNotifications(defaultValue: NSData = NSData()) -> NSData? {
      if let value = NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) {
        return value as? NSData
      }
      
      Logger.Warn("\(self.rawValue) isn't set, setting and returning default value \(defaultValue)")
      
      self.setLocalNotifications(defaultValue)
      return defaultValue
    }
    
    /// clears the key from UserDefaults
    func removeKey() {
      return NSUserDefaults.standardUserDefaults().removeObjectForKey(self.rawValue)
    }
  }
  
  /// Syncronize standardUserDefaults
  class func syncronize(){
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  /// Clears all values
  class func clear(){
    UserSetting.allValues.foreach({$0.removeKey()})
  }
}