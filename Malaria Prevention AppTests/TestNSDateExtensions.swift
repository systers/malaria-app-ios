import XCTest
import Foundation
@testable import Malaria_Prevention_App

class TestNSDateExtensions: XCTestCase {
  
  func testCreation() {
    XCTAssertEqual("2015-01-01",
                   NSDate.from(2015, month: 1, day: 1).formatWith("yyyy-MM-dd"))
  }
  
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
  
  func testAdd() {
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
  
  func testSubtract() {
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
    XCTAssertEqual(true, d1.sameDayAs(d2))
  }
  
  func testSameClock() {
    let date1 = NSDate.from(2015, month: 4, day: 1, hour: 10, minute: 1)
    let date2 = NSDate.from(2014, month: 1, day: 10, hour: 10, minute: 1)
    XCTAssertTrue(date1.sameClockTimeAs(date2))
    
    let date3 = NSDate.from(2015, month: 1, day: 10, hour: 9, minute: 1)
    XCTAssertFalse(date1.sameClockTimeAs(date3))
  }
  
  func testSameWeek() {
    var d1 = NSDate.from(2015, month: 6, day: 6) //saturday
    
    //0 = Saturday, 1 = Sunday, 2 = Monday
    d1 += NSCalendar.currentCalendar().firstWeekday.day
    
    XCTAssertFalse(d1.sameWeekAs(d1 - 1.day))
    XCTAssertTrue(d1.sameWeekAs(d1))
    XCTAssertTrue(d1.sameWeekAs(d1 + 1.day))
    XCTAssertTrue(d1.sameWeekAs(d1 + 2.day))
    XCTAssertTrue(d1.sameWeekAs(d1 + 3.day))
    XCTAssertTrue(d1.sameWeekAs(d1 + 4.day))
    XCTAssertTrue(d1.sameWeekAs(d1 + 5.day))
    XCTAssertTrue(d1.sameWeekAs(d1 + 6.day))
    XCTAssertFalse(d1.sameWeekAs(d1 + 7.day))
    
    //test year transition
    let d2014 = NSDate.from(2014, month: 12, day: 31)
    let d2015 = NSDate.from(2015, month: 1, day: 1)
    XCTAssertTrue(d2014.sameWeekAs(d2015))
  }
  
  func testMonthComparator() {
    let m0 = NSDate.from(2013, month: 1, day: 31)
    let m1 = NSDate.from(2014, month: 1, day: 31)
    let m3 = NSDate.from(2014, month: 1, day: 31)
    let m4 = NSDate.from(2015, month: 1, day: 31)
    let m42 = NSDate.from(2015, month: 1, day: 1)
    
    
    XCTAssertTrue(m0.happensMonthsBefore(m1))
    XCTAssertTrue(m0.happensMonthsBefore(m4))
    XCTAssertTrue(m3.happensMonthsBefore(m4))
    
    XCTAssertTrue(m1.happensMonthsAfter(m0))
    XCTAssertTrue(m4.happensMonthsAfter(m0))
    XCTAssertTrue(m4.happensMonthsAfter(m3))
    
    XCTAssertTrue(m4.sameMonthAs(m42))
    XCTAssertFalse(m4.sameMonthAs(m0))
    XCTAssertFalse(m4.sameMonthAs(m1))
  }
  
  func testEndOfDay() {
    let d1 = NSDate.from(2014, month: 1, day: 1, hour: 23, minute: 59)
    let d2 = NSDate.from(2014, month: 1, day: 1, hour: 0, minute: 0)
    
    XCTAssertTrue(d1.sameClockTimeAs(d1.endOfDay))
    XCTAssertTrue(d1.sameClockTimeAs(d2.endOfDay))
  }
  
  func testDaysBetween() {
    let d1 = NSDate()
    
    //d2 is more recent
    let d2 = d1 + 3.day
    XCTAssertEqual((d2 - d1), 3)
    XCTAssertEqual((d1 - d2), -3)
    
    let d3 = d1 + 1.week
    XCTAssertEqual((d3 - d1), 7)
  }
  
  func testCompontents() {
    let date = NSDate.from(2015, month: 4, day: 1, hour: 10, minute: 1)
    XCTAssertEqual(date.day, 1)
    XCTAssertEqual(date.month, 4)
    XCTAssertEqual(date.year, 2015)
  }
  
  func testStartDay() {
    let date = NSDate.from(2015, month: 4, day: 1, hour: 10, minute: 1)
    //test start of day
    let startDay = date.startOfDay
    XCTAssertEqual(startDay.day, 1)
    XCTAssertEqual(startDay.month, 4)
    XCTAssertEqual(startDay.year, 2015)
    XCTAssertEqual(startDay.hour, 0)
    XCTAssertEqual(startDay.minutes, 0)
  }
  
  func testEndOfWeek() {
    var d1 = NSDate.from(2015, month: 6, day: 6, hour: 12, minute: 11) // Saturday.
    // 0 = Saturday, 1 = Sunday, 2 = Monday = Normalize.
    d1 += NSCalendar.currentCalendar().firstWeekday.day
    
    let endWeek = NSDate.from(2015, month: 6, day: 12 + NSCalendar.currentCalendar().firstWeekday - 1, hour: 23, minute: 59)
    
    
    XCTAssertTrue(d1.endOfWeek.sameDayAs(endWeek))
    XCTAssertTrue(d1.endOfWeek.sameClockTimeAs(endWeek))
  }
  
  func testEndCurrentMonth() {
    /// Test endCurrentMonth.
    let date2 = NSDate.from(2015, month: 7, day: 5, hour: 10, minute: 1)
    XCTAssertTrue(date2.endOfCurrentMonth.sameDayAs(NSDate.from(2015, month: 7, day: 31, hour: 10, minute: 1).endOfDay))
    XCTAssertTrue(date2.endOfCurrentMonth.sameClockTimeAs(NSDate.from(2015, month: 7, day: 31, hour: 10, minute: 1).endOfDay))
    
    let date3 = NSDate.from(2015, month: 2, day: 5)
    XCTAssertTrue(date3.endOfCurrentMonth.sameDayAs(NSDate.from(2015, month: 2, day: 28).endOfDay))
    XCTAssertTrue(date3.endOfCurrentMonth.sameClockTimeAs(NSDate.from(2015, month: 2, day: 28).endOfDay))
    
    
    let date4 = NSDate.from(2015, month: 2, day: 28)
    XCTAssertTrue(date4.endOfCurrentMonth.sameDayAs(date4.endOfDay))
    XCTAssertTrue(date4.endOfCurrentMonth.sameClockTimeAs(date4.endOfDay))
    
  }
  
  
}
