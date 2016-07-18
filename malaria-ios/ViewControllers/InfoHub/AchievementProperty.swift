import Foundation
import CoreData

/// One of the conditions so that an achievement can be unlocked.

class AchievementProperty: NSManagedObject {
  
  enum ActivationMethod: String {
    case Greater = ">"
    case Lesser = "<"
    case Equal = "="
  }
  
  @NSManaged var activation: String?
  @NSManaged var activationValue: NSNumber?
  @NSManaged var currentValue: NSNumber?
  @NSManaged var initialValue: NSNumber?
  @NSManaged var name: String?
  
  func isActive() -> Bool {
    
    switch activation! {
    case ">": return Int(currentValue!) > Int(activationValue!)
    case "<": return Int(currentValue!) < Int(activationValue!)
    case "=": return currentValue == activationValue
    default: return false
    }
    
  }

}
