extension String {
  
  // Check if the user copy-pastes something in the input fields
  
  func isNumber() -> Bool {
    let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
    
    return self.rangeOfCharacterFromSet(invalidCharacters, options: [], range: self.startIndex ..< self.endIndex) == nil
  }
  
  func toReminderValue() -> PillStatusNotificationsManager.ReminderInterval {
    switch self {
    case "4 days": return .FourDays
    case "1 week": return .OneWeek
    case "2 weeks": return .TwoWeeks
    case "4 weeks": return .FourWeeks
    default: return .OneWeek
    }
  }
  
 func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(self)
  }
}