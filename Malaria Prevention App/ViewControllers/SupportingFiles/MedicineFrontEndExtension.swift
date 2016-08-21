import Foundation

/// Decoupled from the backend. This enum is only relevant for the frontend.

extension Medicine {
  
  /**
   Types of pills:
   - `doxycycline`: Daily.
   - `malarone`: Daily.
   - `mefloquine`: Weekly.
   */
  
  enum Pill: String {
    static let allValues = [Pill.doxycycline, Pill.malarone, Pill.mefloquine]
    
    case doxycycline = "Doxycycline"
    case malarone = "Malarone"
    case mefloquine = "Mefloquine"
    
    /**
     Returns the interval of the pill. 7 if mefloquine, 1 otherwise.
     
     - returns: The pill interval.
     */
    
    func interval() -> Int {
      return self == Medicine.Pill.mefloquine ? 7 : 1
    }
    
    /**
     Returns the name of the pill.
     
     - returns: The name of the pill.
     */
    
    func name() -> String {
      return self.rawValue
    }
  }
}