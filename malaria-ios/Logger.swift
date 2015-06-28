import Foundation

class Logger{

    class func Info(message: String, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
        Logger.Write("INFO", message: message, function: function, path: path, line: line)
    }
    
    class func Warn(message: String, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
        Logger.Write("WARN", message: message, function: function, path: path, line: line)
    }
    
    class func Error(message: String, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__){
       Logger.Write("ERRO", message: message, function: function, path: path, line: line)
    }
    
    class func Write(prefix: String, message: String, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
        var file = path.lastPathComponent
        file = file.substringToIndex(find(file, ".")!)
        let location = "::".join([file, function, line.description])
        
        println("[\(prefix.uppercaseString)] - " + location + " \t" + message)
    }
}