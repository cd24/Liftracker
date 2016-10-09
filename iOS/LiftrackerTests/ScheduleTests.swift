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
        
        // Mon, 12 Sep 2016 10:38:31 GMT
        let startDate = Date(timeIntervalSince1970: 1473676711)
        
        // verification dates
        let teusday = Date(timeIntervalSince1970: 1473763111)
        let wednesday = Date(timeIntervalSince1970: 1473849511)
        let thursday = Date(timeIntervalSince1970: 1473935911)
        let friday = Date(timeIntervalSince1970: 1474022311)
        let saturday = Date(timeIntervalSince1970: 1474108711)
        let sunday = Date(timeIntervalSince1970: 1474195111)
        
        // get the dates from the utility and check against the dates
        var teusFromScheduler: Date = Date()
        
        self.measure {
            teusFromScheduler = ScheduleUtil.getNextOccurance(day: .Teusday, fromDate: startDate)
            XCTAssert( self.isSameDay(date1: teusday, date2: teusFromScheduler) )
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
        XCTAssert( isSameDay(date1: sunday, date2: sunFromScheduler) )
    }
    
    func testSundayDate() {
        
        // Sun, 11 Sep 2016 10:38:31 GMT
        let startDate = Date(timeIntervalSince1970: 1473590311)
        
        // verification dates
        let monday = Date(timeIntervalSince1970: 1473676711)
        let teusday = Date(timeIntervalSince1970: 1473763111)
        let wednesday = Date(timeIntervalSince1970: 1473849511)
        let thursday = Date(timeIntervalSince1970: 1473935911)
        let friday = Date(timeIntervalSince1970: 1474022311)
        let saturday = Date(timeIntervalSince1970: 1474108711)
        
        // get the dates from the utility and check against the dates
        
        let mondayFromScheduler = ScheduleUtil.getNextOccurance(day: .Monday, fromDate: startDate)
        XCTAssert( isSameDay(date1: mondayFromScheduler, date2: monday))
        
        var teusFromScheduler: Date = Date()
        
        self.measure {
            teusFromScheduler = ScheduleUtil.getNextOccurance(day: .Teusday, fromDate: startDate)
            XCTAssert( self.isSameDay(date1: teusday, date2: teusFromScheduler) )
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
    
    func printWeekdayInt( date: Date) {
        
        if let calendar = NSCalendar(identifier: .gregorian) {
            
            let component = calendar.components(.weekday, from: date)
            NSLog("\(component)")
        }
    }
}
