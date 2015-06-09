import Foundation

func logger(message: String, function: String = __FUNCTION__, path: String = __FILE__, line: Int = __LINE__) {
    var file = path.lastPathComponent
    file = file.substringToIndex(find(file, ".")!)
    let location = "::".join([file, function, line.description])
    
    println(location + " \t" + message)
}