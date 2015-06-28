import Foundation
import UIKit

var inTestEnvironment: Bool{
    let environment = NSProcessInfo.processInfo().environment as! [String : AnyObject]
    return (environment["XCInjectBundle"] as? String)?.pathExtension == "xctest"
}