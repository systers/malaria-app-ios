extension String {
  
  // Check if the user copy-pastes something in the input fields.
  
  func isNumber() -> Bool {
    let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
    
    return self.rangeOfCharacterFromSet(invalidCharacters, options: [], range: self.startIndex ..< self.endIndex) == nil
  }
  
  func toReminderValue() -> PillStatusNotificationsManager.ReminderInterval {
    switch self {
    case "4 days": return .fourDays
    case "1 week": return .oneWeek
    case "2 weeks": return .twoWeeks
    case "4 weeks": return .fourWeeks
    default: return .oneWeek
    }
  }
  
 func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(self)
  }
  
  func toDate(withFormat format: String = "HH:mm") -> NSDate {
    let formatter = NSDateFormatter()
    formatter.dateFormat = format
    return formatter.dateFromString(self)!
  }
  
    func localized(language: String) -> String {
      
      let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
      let bundle = NSBundle(path: path!)
      
      return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}