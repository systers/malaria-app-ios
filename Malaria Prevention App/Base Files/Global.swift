import Foundation
import UIKit

/// Used when presenting alert views. Mostly presented in `Messages` class extension.
typealias AlertText = (title: String, message: String)
typealias AchievementObject = (tag: String, achievements: [Achievement])

class Global {
    
    // Methods to get the system information. 
    static func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedSame
    }
    
    static func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending
    }
    
    static func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
    }
    
    static func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending
    }
    
    static func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedDescending
    }
}