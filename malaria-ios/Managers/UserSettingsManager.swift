import Foundation

class UserSettingsManager{
    
    /// Sets an UserSetting
    /// :param: `UserSetting`: the setting to be changed
    /// :param: `Bool`: value
    class func setBool(key: UserSetting, _ value: Bool){
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key.rawValue)
    }

    /// Gets an UserSetting value
    /// :param: `UserSetting`: the setting to be changed
    class func getBool(key: UserSetting) -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(key.rawValue) ?? false
    }

    /// Syncronize standardUserDefaults
    class func syncronize(){
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /// Clears all values
    class func clear(){
        for setting in UserSetting.allValues{
            NSUserDefaults.standardUserDefaults().removeObjectForKey(setting.rawValue)
        }
    }
}