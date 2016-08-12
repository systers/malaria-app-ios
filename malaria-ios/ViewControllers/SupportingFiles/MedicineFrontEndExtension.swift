import Foundation

/// Decoupled from the backend. This enum is only relevant for the frontend.

extension Medicine {
  
  /**
   Types of pills:
   - `Doxycycline`: Daily
   - `Malarone`: Daily
   - `Mefloquine`: Weekly
   */
  
  enum Pill : String {
    static let allValues = [Pill.Doxycycline, Pill.Malarone, Pill.Mefloquine]
    
    case Doxycycline
    case Malarone
    case Mefloquine
    
    /**
     Returns the interval of the pill. 7 if Mefloquine, 1 otherwise
     
     - returns: `Int`: the pill interval
     */
    
    func interval() -> Int {
      return self == Medicine.Pill.Mefloquine ? 7 : 1
    }
    
    /**
     Returns the name of the pill
     
     - returns: `String`: the name of the pill
     */
    
    func name() -> String{
      return self.rawValue
    }
  }
}