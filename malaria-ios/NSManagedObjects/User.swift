import Foundation
import CoreData

class User: NSManagedObject {
  
  static private let MinimumCharacterLength = 2
  static private let MinimumVolunteerAge = 12
  static private let MaximumVolunteerAge = 90
  
  enum UserValidationError: String, ErrorType {
    case NoFirstNameProvided = "Please insert your first name."
    case NoLastNameProvided = "Please insert your last name."
    case NoAgeProvided = "Please insert your age."
    case NoEmailProvided = "Please insert your email."
    
    case FirstNameLength = "First name must have minimum two characters."
    case LastNameLength = "Last name must have minimum two characters."
    case LocationLength = "Location must have minimum two characters."
    case PhoneLength = "Phone must have minimum two characters."
    case GenderLength = "Gender must have minimum two characters."
    
    case InvalidAge = "Please insert real age."
    case InvalidEmail = "Please insert a valid email."
    case InvalidPhone = "Please insert a valid phone number."
  }
  
  static func isUserAlreadyCreated() -> Bool {
    let newContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    return User.retrieve(User.self, context: newContext!).count > 0
  }
  
  /**
   Defines or updates current user. It makes sure only one user exists at a time.
   
   - return MethodReturnType: A tuple which can contain the created user or,
   if the user creation failed, the corespondent error as `String`.
   */
  
  static func define(firstName: String?,
                     lastName: String?,
                     age: String?,
                     email: String?,
                     gender: String?,
                     location: String?,
                     phone: String?) throws -> User {
    
    do {
      try validateData(firstName,
                       lastName: lastName,
                       age: age,
                       location: location,
                       email: email,
                       gender: gender,
                       phone: phone)
    }
    catch let error as UserValidationError {
      throw error
    }
    
    let newContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    
    User.clear(User.self, context: newContext!)
    
    let user = User.create(User.self, context: newContext!)
    
    user.firstName = firstName!
    user.lastName  = lastName!
    user.age = Int64(age!)!
    user.location = location!
    user.gender = gender!
    user.phone = phone!
    user.email = email!
    
    CoreDataHelper.sharedInstance.saveContext(newContext!)
    
    Logger.Info("User created.")
    
    return user
  }
  
  static private func validateData(firstName: String?,
                                   lastName: String?,
                                   age: String?,
                                   location: String?,
                                   email: String?,
                                   gender: String?,
                                   phone: String?)
    throws -> Bool {
      
      guard let firstName = firstName else {
        throw UserValidationError.NoFirstNameProvided
      }
      
      guard let lastName = lastName else {
        throw UserValidationError.NoLastNameProvided
      }
      
      if firstName.characters.count < MinimumCharacterLength {
        throw UserValidationError.FirstNameLength
      }
      
      if lastName.characters.count < MinimumCharacterLength {
        throw UserValidationError.LastNameLength
      }
      
      if gender?.characters.count < MinimumCharacterLength {
        throw UserValidationError.GenderLength
      }
      
      guard let age = Int(age!) else {
        throw UserValidationError.NoAgeProvided
      }
      
      if age < MinimumVolunteerAge || age > MaximumVolunteerAge  {
        throw UserValidationError.InvalidAge
      }
      
      guard let email = email else {
        throw UserValidationError.NoEmailProvided
      }
      
      if !email.isValidEmail() {
        throw UserValidationError.InvalidEmail
      }
      
      if location?.characters.count < MinimumCharacterLength {
        throw UserValidationError.LocationLength
      }
      
      if phone?.characters.count < MinimumCharacterLength {
        throw UserValidationError.PhoneLength
      }
      
      if phone?.isNumber() == false {
        throw UserValidationError.InvalidPhone
      }
      
      return true
  }
}