import Foundation


//Manage NSUserDefaults
class UserSettingsManager{
    
    class func setBool(key: UserSetting, _ value: Bool){
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key.rawValue)
    }
    
    class func getBool(key: UserSetting) -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(key.rawValue) ?? false
    }
    
    class func setInt(key: UserSetting, _ value: Int){
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: key.rawValue)
    }
    
    class func getInt(key: UserSetting) -> Int{
        return NSUserDefaults.standardUserDefaults().integerForKey(key.rawValue) ?? 0
    }
    
    class func setObject(key: UserSetting, _ value: AnyObject){
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key.rawValue)
    }
    
    class func getObject(key: UserSetting) -> AnyObject?{
        return NSUserDefaults.standardUserDefaults().objectForKey(key.rawValue)
    }
    
    class func clear(){
        for setting in UserSetting.allValues{
            NSUserDefaults.standardUserDefaults().removeObjectForKey(setting.rawValue)
        }
    }
    
    class func syncronize(){
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}