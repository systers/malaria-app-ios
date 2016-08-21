import Foundation

/// Logging mechanism.

class Logger {
  
  /**
   Logs an Information message.
   
   - parameter message: The message.
   - parameter function: The function which logs the info.
   - parameter path: The file in which the log was called.
   - parameter line: The line in which the log was called.
   */
  
  class  func Info(message: CustomStringConvertible,
                   function: String = #function,
                   path: String = #file,
                   line: Int = #line) {
    Logger.Write("INFO", message: message, function: function, path: path, line: line)
  }
  
  /**
   Logs a Warning message.
   
   - parameter message: The message.
   - parameter function: The function which logs the info.
   - parameter path: The file in which the log was called.
   - parameter line: The line in which the log was called.
   */
  
  class func Warn(message: CustomStringConvertible,
                  function: String = #function,
                  path: String = #file,
                  line: Int = #line) {
    Logger.Write("WARN", message: message, function: function, path: path, line: line)
  }
  
  /** Logs a Error message
   
   - parameter message: The message.
   - parameter function: The function which logs the info.
   - parameter path: The file in which the log was called.
   - parameter line: The line in which the log was called.
   */
  
  class func Error(message: CustomStringConvertible,
                   function: String = #function,
                   path: String = #file,
                   line: Int = #line) {
    Logger.Write("ERRO", message: message, function: function, path: path, line: line)
  }
  
  class private func Write(prefix: String,
                           message: CustomStringConvertible,
                           function: String = #function,
                           path: String = #file,
                           line: Int = #line) {
    
    var file = NSURL(fileURLWithPath: path).lastPathComponent!.description
    file = file.substringToIndex(file.characters.indexOf(".")!)
    let location = [file, function, line.description].joinWithSeparator("::")
    
    print("[\(prefix.uppercaseString)] - \(location) \t\(message)")
  }
}