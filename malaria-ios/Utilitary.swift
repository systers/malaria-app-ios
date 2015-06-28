import Foundation
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func inTestEnvironment() -> Bool{
    let environment = NSProcessInfo.processInfo().environment as! [String : AnyObject]
    return (environment["XCInjectBundle"] as? String)?.pathExtension == "xctest"
}