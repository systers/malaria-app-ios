import XCTest
import Foundation

class TestNSDateExtensions: XCTestCase {
    
    func testGreaterThan() {
        
        let a = NSDate.from(2015, month: 1, day: 1)
        let b = NSDate.from(2015, month: 1, day: 2)
        let c = NSDate.from(2015, month: 2, day: 1)
        let d = NSDate.from(2016, month: 1, day: 1)
        
        XCTAssertEqual(true, b > a)
        XCTAssertEqual(true, c > a)
        XCTAssertEqual(true, d > a)
    }
    
    func testLessThan() {
        let a = NSDate.from(2015, month: 1, day: 1)
        let b = NSDate.from(2015, month: 1, day: 2)
        let c = NSDate.from(2015, month: 2, day: 1)
        let d = NSDate.from(2016, month: 1, day: 1)
        
        XCTAssertEqual(true, a < b)
        XCTAssertEqual(true, a < c)
        XCTAssertEqual(true, a < d)
    }
    
    func testAdd(){
        var a = NSDate.from(2015, month: 1, day: 15)
        XCTAssertEqual(true, a < (a + 1.day))
        XCTAssertEqual(true, a < (a + 20.day))
        XCTAssertEqual(true, a < (a + 1.month))
        XCTAssertEqual(true, a < (a + 1.year))
        XCTAssertEqual(true, a == (a + 0.year))
        XCTAssertEqual(true, a == (a + 0.day))
        XCTAssertEqual(true, a == (a + 0.month))
        
        let b = a
        a += 1.day
        
        XCTAssertEqual(true, b < a)
    }
    
    func testSubtract(){
        var a = NSDate.from(2015, month: 1, day: 15)
        XCTAssertEqual(true, a > (a - 1.day))
        XCTAssertEqual(true, a > (a - 20.day))
        XCTAssertEqual(true, a > (a - 1.month))
        XCTAssertEqual(true, a > (a - 1.year))
        XCTAssertEqual(true, a == (a - 0.year))
        XCTAssertEqual(true, a == (a - 0.day))
        XCTAssertEqual(true, a == (a - 0.month))
        
        let b = a
        a -= 1.day
        
        XCTAssertEqual(true, a < b)
    }
    
    func testSameDate() {
        let d1 = NSDate()
        let d2 = d1 + 7.day - 7.day
        XCTAssertEqual(true, NSDate.areDatesSameDay(d1, dateTwo: d2))
    }
    
    func testSameWeek() {
        var d1 = NSDate.from(2015, month: 6, day: 6) //saturday
        
        //0 = Saturday, 1 = Sunday, 2 = Monday
        d1 += NSCalendar.currentCalendar().firstWeekday.day
        
        XCTAssertFalse(NSDate.areDatesSameWeek(d1, dateTwo: d1 - 1.day))
        XCTAssertTrue(NSDate.areDatesSameWeek(d1, dateTwo: d1 + 1.day))
        XCTAssertTrue(NSDate.areDatesSameWeek(d1, dateTwo: d1 + 2.day))
        XCTAssertTrue(NSDate.areDatesSameWeek(d1, dateTwo: d1 + 3.day))
        XCTAssertTrue(NSDate.areDatesSameWeek(d1, dateTwo: d1 + 4.day))
        XCTAssertTrue(NSDate.areDatesSameWeek(d1, dateTwo: d1 + 5.day))
        XCTAssertTrue(NSDate.areDatesSameWeek(d1, dateTwo: d1 + 6.day))
        XCTAssertFalse(NSDate.areDatesSameWeek(d1, dateTwo: d1 + 7.day))
    }

}