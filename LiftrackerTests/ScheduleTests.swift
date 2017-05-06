//
//  ScheduleTests.swift
//  Liftracker
//
//  Created by John McAvey on 9/18/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import XCTest
@testable import Liftracker

class ScheduleTests : XCTestCase {
    
    // Sun, 11 Sep 2016 10:38:31 GMT
    let startDate = Date(timeIntervalSince1970: 1473590311)
    
    // verification dates
    let monday = Date(timeIntervalSince1970: 1473676711)
    let teusday = Date(timeIntervalSince1970: 1473763111)
    let wednesday = Date(timeIntervalSince1970: 1473849511)
    let thursday = Date(timeIntervalSince1970: 1473935911)
    let friday = Date(timeIntervalSince1970: 1474022311)
    let saturday = Date(timeIntervalSince1970: 1474108711)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test getting the next date from each weekday
    
    func testMondayDate() {
        
        // get the dates from the utility and check against the dates
        var teusFromScheduler: Date = Date()
        
        self.measure {
            teusFromScheduler = ScheduleUtil.getNextOccurance(day: .Teusday, fromDate: self.startDate)
            XCTAssert( self.isSameDay(date1: self.teusday, date2: teusFromScheduler) )
        }
        
        let wedFromScheduler = ScheduleUtil.getNextOccurance(day: .Wednesday, fromDate: startDate)
        XCTAssert( isSameDay(date1: wednesday, date2: wedFromScheduler) )
        
        let thurFromScheduler = ScheduleUtil.getNextOccurance(day: .Thursday, fromDate: startDate)
        XCTAssert( isSameDay(date1: thursday, date2: thurFromScheduler) )
        
        let friFromScheduler = ScheduleUtil.getNextOccurance(day: .Friday, fromDate: startDate)
        XCTAssert( isSameDay(date1: friday, date2: friFromScheduler) )
        
        let satFromScheduler = ScheduleUtil.getNextOccurance(day: .Saturday, fromDate: startDate)
        XCTAssert( isSameDay(date1: saturday, date2: satFromScheduler) )
        
        let sunFromScheduler = ScheduleUtil.getNextOccurance(day: .Sunday, fromDate: startDate)
        XCTAssert( isSameDay(date1: self.startDate, date2: sunFromScheduler) )
    }
    
    func testSundayDate() {
        
        // get the dates from the utility and check against the dates
        
        let mondayFromScheduler = ScheduleUtil.getNextOccurance(day: .Monday, fromDate: startDate)
        XCTAssert( isSameDay(date1: mondayFromScheduler, date2: monday))
        
        var teusFromScheduler: Date = Date()
        
        self.measure {
            teusFromScheduler = ScheduleUtil.getNextOccurance(day: .Teusday, fromDate: self.startDate)
            XCTAssert( self.isSameDay(date1: self.teusday, date2: teusFromScheduler) )
        }
        
        let wedFromScheduler = ScheduleUtil.getNextOccurance(day: .Wednesday, fromDate: startDate)
        XCTAssert( isSameDay(date1: wednesday, date2: wedFromScheduler) )
        
        let thurFromScheduler = ScheduleUtil.getNextOccurance(day: .Thursday, fromDate: startDate)
        XCTAssert( isSameDay(date1: thursday, date2: thurFromScheduler) )
        
        let friFromScheduler = ScheduleUtil.getNextOccurance(day: .Friday, fromDate: startDate)
        XCTAssert( isSameDay(date1: friday, date2: friFromScheduler) )
        
        let satFromScheduler = ScheduleUtil.getNextOccurance(day: .Saturday, fromDate: startDate)
        XCTAssert( isSameDay(date1: saturday, date2: satFromScheduler) )
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        
        if let calendar = NSCalendar(identifier: .gregorian) {
            let d1_components = calendar.components([.day, .month, .year], from: date1)
            let d2_components = calendar.components([.day, .month, .year], from: date2)
            
            return  d1_components.weekday   == d2_components.weekday &&
                    d1_components.day       == d2_components.day &&
                    d1_components.month     == d2_components.month &&
                    d1_components.year      == d2_components.year
        }
        
        // Unable to get the calendar
        return false
    }
    
    func testScheduleActive() {
        // Mon, teus,thurs, sat (zero front padded)
        // Remember that binary is read right to left
        let schedule: UInt8 = 0b01010110
        XCTAssertTrue( ScheduleUtil.active(on: monday, schedule), "Should be active on monday" )
        XCTAssertTrue( ScheduleUtil.active(on: teusday, schedule), "Should be active on teusday" )
        XCTAssertFalse( ScheduleUtil.active(on: wednesday, schedule), "Shouldn't be active on wednesday" )
        XCTAssertTrue( ScheduleUtil.active(on: thursday, schedule), "Should be active on thursday")
        XCTAssertFalse( ScheduleUtil.active(on: friday, schedule), "Shouldn't be active on friday" )
        XCTAssertTrue( ScheduleUtil.active(on: saturday, schedule), "Should be active on saturday")
    }
    
    func testScheduleToDays() {
        // Mon, teus, thurs, fri, sat (zero front padded)
        // Remember that binary is read right to left
        let schedule: UInt8 = 0b01110110
        var days = ScheduleUtil.getDays(for: schedule)
        let answer: [Day] = [
            .Monday,
            .Teusday,
            .Thursday,
            .Friday,
            .Saturday
        ]
        print(days)
        XCTAssertEqual(days.count, answer.count)
        answer.forEach { XCTAssert( days.contains($0) ) }
        
        let schedule2: UInt8 = 0b00000000
        let answer2: [Day] = []
        days = ScheduleUtil.getDays(for: schedule2)
        XCTAssertEqual(days.count, 0)
        answer2.forEach { XCTAssert( days.contains($0) ) }
        
        let schedule3: UInt8 = 0b11111111
        days = ScheduleUtil.getDays(for: schedule3)
        let answer3: [Day] = [
            .Monday,
            .Teusday,
            .Wednesday,
            .Thursday,
            .Friday,
            .Saturday,
            .Sunday
        ]
        XCTAssertEqual(days.count, answer3.count)
        answer3.forEach { XCTAssert( days.contains($0) ) }
    }
    
    func printWeekdayInt( date: Date) {
        
        if let calendar = NSCalendar(identifier: .gregorian) {
            
            let component = calendar.components(.weekday, from: date)
            NSLog("\(component)")
        }
    }
}
