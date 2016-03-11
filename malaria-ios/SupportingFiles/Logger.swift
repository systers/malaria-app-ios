import Foundation

extension String : CustomStringConvertible {
  public var description: String { get { return self }}
}

/// Logging mechanism
public class Logger{
  /// Logs an Information message
  ///
  /// - parameter `Printable`:: The message
  class public func Info(message: CustomStringConvertible, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
    Logger.Write("INFO", message: message, function: function, path: path, line: line)
  }

  /// Logs a Warning message
  ///
  /// - parameter `Printable`:: The message
  class public func Warn(message: CustomStringConvertible, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
    Logger.Write("WARN", message: message, function: function, path: path, line: line)
  }

  /// Logs a Error message
  ///
  /// - parameter `Printable`:: The message
  class public func Error(message: CustomStringConvertible, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__){
    Logger.Write("ERRO", message: message, function: function, path: path, line: line)
  }

  class private func Write(prefix: String, message: CustomStringConvertible, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {

    guard let url = NSURL(string: path),
      let lastPathComponent = url.lastPathComponent
      else {
        return
    }

    var file = lastPathComponent.description
    file = file.substringToIndex(file.characters.indexOf(".")!)
    let location = [file, function, line.description].joinWithSeparator("::")

    print("[\(prefix.uppercaseString)] - \(location) \t\(message)")
  }
}