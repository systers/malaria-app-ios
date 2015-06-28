import Foundation

extension String : Printable {
    public var description: String { get { return self }}
}

class Logger{
    
    /// Logs an Information message
    ///
    /// :param: `Printable`: The message
    class func Info(message: Printable, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
        Logger.Write("INFO", message: message, function: function, path: path, line: line)
    }
    
    /// Logs a Warning message
    ///
    /// :param: `Printable`: The message
    class func Warn(message: Printable, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
        Logger.Write("WARN", message: message, function: function, path: path, line: line)
    }
    
    /// Logs a Error message
    ///
    /// :param: `Printable`: The message
    class func Error(message: Printable, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__){
       Logger.Write("ERRO", message: message, function: function, path: path, line: line)
    }
    
    class func Write(prefix: String, message: Printable, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
        var file = path.lastPathComponent
        file = file.substringToIndex(find(file, ".")!)
        let location = "::".join([file, function, line.description])
        
        println("[\(prefix.uppercaseString)] - \(location) \t\(message)")
    }
}