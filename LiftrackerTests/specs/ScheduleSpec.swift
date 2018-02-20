//
//  ScheduleSpec.swift
//  LiftrackerTests
//
//  Created by John McAvey on 2/11/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Liftracker

class ScheduleSpec: QuickSpec {
    private lazy var alwaysActive: Schedule = {
        return Schedule(UInt8(0b11111111))
    }()
    private lazy var neverActive: Schedule = {
        return Schedule(UInt8(0))
    }()
    let aSunday = Date(timeIntervalSince1970: 1473590311)
    let aMonday = Date(timeIntervalSince1970: 1473676711)
    let aTeusday = Date(timeIntervalSince1970: 1473763111)
    let aWednesday = Date(timeIntervalSince1970: 1473849511)
    let aThursday = Date(timeIntervalSince1970: 1473935911)
    let aFriday = Date(timeIntervalSince1970: 1474022311)
    let aSaturday = Date(timeIntervalSince1970: 1474108711)
    let calendar = Calendar(identifier: .gregorian)
    
    override func spec() {
        describe("initialization") {
            it("can be constructed from a UInt8") {
                let schedule: UInt8 = 0
                let _ = Schedule(schedule)
            }
            it("can be constructed from an Int16") {
                let schedule: Int16 = 0
                let _ = Schedule(schedule)
            }
            it("can be constructed from an array") {
                let _ = Schedule([])
            }
            it("can be converted to a UInt8") {
                let schedule: UInt8 = 0b0
                let _ = Schedule(schedule).asByte()
            }
            it("preserves the bytes through 7th positon") {
                let schedule: UInt8 = 0b01111111
                let sch = Schedule(schedule)
                expect(sch.asByte()).to(be(schedule))
            }
            it("destorys information in the 8th position") {
                let schedule: UInt8 = 0b10000000
                let sch = Schedule(schedule)
                expect(sch.asByte()).to(be(UInt8(0)))
            }
            it("reads Sunday from the first bit") {
                let schedule = Schedule(UInt8(0b00000001))
                expect(schedule.days).to(contain([Day.Sunday]))
                expect(schedule.days).toNot(contain([Day.Monday, Day.Teusday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday]))
                expect(schedule.active(on: self.aSunday)).to(beTrue())
                expect(schedule.active(on: self.aMonday)).to(beFalse())
                expect(schedule.active(on: self.aTeusday)).to(beFalse())
                expect(schedule.active(on: self.aWednesday)).to(beFalse())
                expect(schedule.active(on: self.aThursday)).to(beFalse())
                expect(schedule.active(on: self.aFriday)).to(beFalse())
                expect(schedule.active(on: self.aSaturday)).to(beFalse())
            }
            it("reads Monday from the second bit") {
                let schedule = Schedule(UInt8(0b00000010))
                expect(schedule.days).to(contain([.Monday]))
                expect(schedule.days).toNot(contain([Day.Sunday, Day.Teusday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday]))
                expect(schedule.active(on: self.aSunday)).to(beFalse())
                expect(schedule.active(on: self.aMonday)).to(beTrue())
                expect(schedule.active(on: self.aTeusday)).to(beFalse())
                expect(schedule.active(on: self.aWednesday)).to(beFalse())
                expect(schedule.active(on: self.aThursday)).to(beFalse())
                expect(schedule.active(on: self.aFriday)).to(beFalse())
                expect(schedule.active(on: self.aSaturday)).to(beFalse())
            }
            it("reads Tuesday from the third bit") {
                let schedule = Schedule(UInt8(0b00000100))
                expect(schedule.days).to(contain([Day.Teusday]))
                expect(schedule.days).toNot(contain([Day.Sunday, Day.Monday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday]))
                expect(schedule.active(on: self.aSunday)).to(beFalse())
                expect(schedule.active(on: self.aMonday)).to(beFalse())
                expect(schedule.active(on: self.aTeusday)).to(beTrue())
                expect(schedule.active(on: self.aWednesday)).to(beFalse())
                expect(schedule.active(on: self.aThursday)).to(beFalse())
                expect(schedule.active(on: self.aFriday)).to(beFalse())
                expect(schedule.active(on: self.aSaturday)).to(beFalse())
            }
            it("reads Wednesday from the fourth bit") {
                let schedule = Schedule(UInt8(0b00001000))
                expect(schedule.days).to(contain([Day.Wednesday]))
                expect(schedule.days).toNot(contain([Day.Sunday, Day.Monday, Day.Teusday, Day.Thursday, Day.Friday, Day.Saturday]))
                expect(schedule.active(on: self.aSunday)).to(beFalse())
                expect(schedule.active(on: self.aMonday)).to(beFalse())
                expect(schedule.active(on: self.aTeusday)).to(beFalse())
                expect(schedule.active(on: self.aWednesday)).to(beTrue())
                expect(schedule.active(on: self.aThursday)).to(beFalse())
                expect(schedule.active(on: self.aFriday)).to(beFalse())
                expect(schedule.active(on: self.aSaturday)).to(beFalse())
            }
            it("reads Thursday from the fifth bit") {
                let schedule = Schedule(UInt8(0b00010000))
                expect(schedule.days).to(contain([Day.Thursday]))
                expect(schedule.days).toNot(contain([Day.Sunday, Day.Monday, Day.Teusday, Day.Wednesday, Day.Friday, Day.Saturday]))
                expect(schedule.active(on: self.aSunday)).to(beFalse())
                expect(schedule.active(on: self.aMonday)).to(beFalse())
                expect(schedule.active(on: self.aTeusday)).to(beFalse())
                expect(schedule.active(on: self.aWednesday)).to(beFalse())
                expect(schedule.active(on: self.aThursday)).to(beTrue())
                expect(schedule.active(on: self.aFriday)).to(beFalse())
                expect(schedule.active(on: self.aSaturday)).to(beFalse())
            }
            it("reads Friday from the sixth bit") {
                let schedule = Schedule(UInt8(0b00100000))
                expect(schedule.days).to(contain([Day.Friday]))
                expect(schedule.days).toNot(contain([Day.Sunday, Day.Monday, Day.Teusday, Day.Wednesday, Day.Thursday, Day.Saturday]))
                expect(schedule.active(on: self.aSunday)).to(beFalse())
                expect(schedule.active(on: self.aMonday)).to(beFalse())
                expect(schedule.active(on: self.aTeusday)).to(beFalse())
                expect(schedule.active(on: self.aWednesday)).to(beFalse())
                expect(schedule.active(on: self.aThursday)).to(beFalse())
                expect(schedule.active(on: self.aFriday)).to(beTrue())
                expect(schedule.active(on: self.aSaturday)).to(beFalse())
            }
            it("reads Saturday from the seventh bit") {
                let schedule = Schedule(UInt8(0b01000000))
                expect(schedule.days).to(contain([Day.Saturday]))
                expect(schedule.days).toNot(contain([Day.Sunday, Day.Monday, Day.Teusday, Day.Wednesday, Day.Thursday, Day.Friday]))
                expect(schedule.active(on: self.aSunday)).to(beFalse())
                expect(schedule.active(on: self.aMonday)).to(beFalse())
                expect(schedule.active(on: self.aTeusday)).to(beFalse())
                expect(schedule.active(on: self.aWednesday)).to(beFalse())
                expect(schedule.active(on: self.aThursday)).to(beFalse())
                expect(schedule.active(on: self.aFriday)).to(beFalse())
                expect(schedule.active(on: self.aSaturday)).to(beTrue())
            }
        }
        describe("activity") {
            it("can check activity without input") {
                // in this case it uses `now`
                expect(self.neverActive.active()).to(beFalse())
            }
            it("can check specific dates") {
                expect(self.alwaysActive.active(on: self.aMonday)).to(beTrue())
            }
            it("can check single-day schedules"){
                let schedule = Schedule(UInt8(0b00000010))
                expect(schedule.active(on: self.aSunday)).to(beFalse())
                expect(schedule.active(on: self.aMonday)).to(beTrue())
                expect(schedule.active(on: self.aTeusday)).to(beFalse())
                expect(schedule.active(on: self.aWednesday)).to(beFalse())
                expect(schedule.active(on: self.aThursday)).to(beFalse())
                expect(schedule.active(on: self.aFriday)).to(beFalse())
                expect(schedule.active(on: self.aSaturday)).to(beFalse())
            }
            it("can check multi-day schedules") {
                let schedule = Schedule(UInt8(0b00101010))
                expect(schedule.active(on: self.aSunday)).to(beFalse())
                expect(schedule.active(on: self.aMonday)).to(beTrue())
                expect(schedule.active(on: self.aTeusday)).to(beFalse())
                expect(schedule.active(on: self.aWednesday)).to(beTrue())
                expect(schedule.active(on: self.aThursday)).to(beFalse())
                expect(schedule.active(on: self.aFriday)).to(beTrue())
                expect(schedule.active(on: self.aSaturday)).to(beFalse())
            }
        }
        describe("next occurance") {
            let component = { self.calendar.component($0, from: $1) }
            let theWeekdayOf = { component(.weekday, $0) }
            it("returns today if the schedule is active") {
                // Should work since it should alwasy be day+1
                let nextOccurance = self.alwaysActive.nextOccurance()
                expect(nextOccurance).toNot(beNil())
                expect(theWeekdayOf(nextOccurance!)).to(be(theWeekdayOf(Date())))
            }
            it("skips to tomorrow") {
                let mwfSchedule = Schedule(UInt8(0b00101010))
                let nextFromSaturday = mwfSchedule.nextOccurance(from: self.aSaturday)
                let nextFromSunday = mwfSchedule.nextOccurance(from: self.aSunday)
                let nextFromTuesday = mwfSchedule.nextOccurance(from: self.aTeusday)
                let nextFromThursday = mwfSchedule.nextOccurance(from: self.aThursday)
                
                expect(nextFromSaturday).toNot(beNil())
                expect(nextFromSunday).toNot(beNil())
                expect(nextFromTuesday).toNot(beNil())
                expect(nextFromThursday).toNot(beNil())
                
                expect(theWeekdayOf(nextFromSaturday!)).to(be(theWeekdayOf(self.aMonday)))
                expect(theWeekdayOf(nextFromSunday!)).to(be(theWeekdayOf(self.aMonday)))
                expect(theWeekdayOf(nextFromTuesday!)).to(be(theWeekdayOf(self.aWednesday)))
                expect(theWeekdayOf(nextFromThursday!)).to(be(theWeekdayOf(self.aFriday)))
            }
            it("skips all inactive days") {
                let saturdaySchedule = Schedule(UInt8(0b01000000))
                let nextFromSunday = saturdaySchedule.nextOccurance(from: self.aSunday)
                expect(nextFromSunday).toNot(beNil())
                expect(theWeekdayOf(nextFromSunday!)).to(be(theWeekdayOf(self.aSaturday)))
            }
            it("only adjusts the day component") {
                let saturdaySchedule = Schedule(UInt8(0b01000000))
                let nextFromSunday = saturdaySchedule.nextOccurance(from: self.aSunday)
                expect(nextFromSunday).toNot(beNil())
                expect(component(.year, nextFromSunday!)).to(be(component(.year, self.aSunday)))
                expect(component(.month, nextFromSunday!)).to(be(component(.month, self.aSunday)))
                expect(component(.hour, nextFromSunday!)).to(be(component(.hour, self.aSunday)))
                expect(component(.minute, nextFromSunday!)).to(be(component(.minute, self.aSunday)))
                expect(component(.second, nextFromSunday!)).to(be(component(.second, self.aSunday)))
                expect(component(.nanosecond, nextFromSunday!)).to(be(component(.nanosecond, self.aSunday)))
            }
        }
        // Downstream dependencies
        describe("Date and Calendar assumptions") {
            it("can be initialized using TI since 1970") {
                // Gregorian: Monday, September 12, 2016 10:38:31 AM
                let expected: DateComponents = DateComponents(calendar: self.calendar, timeZone: TimeZone(identifier: "America/Los_Angeles"), era: 1, year: 2016, month: 9, day: 12, hour: 3, minute: 38, second: 31, nanosecond: 0, weekday: 2, weekdayOrdinal: 2, quarter: 0, weekOfMonth: 3, weekOfYear: 38, yearForWeekOfYear: 2016)
                let expectedDate = self.calendar.date(from: expected)
                expect(self.aMonday).to(be(expectedDate))
            }
            it("converts sunday to 1") {
                let weekday = self.calendar.component(.weekday, from: self.aSunday)
                expect(weekday).to(be(1))
            }
            it("converts monday to 2") {
                let weekday = self.calendar.component(.weekday, from: self.aMonday)
                expect(weekday).to(be(2))
            }
            it("converts teusday to 3") {
                let weekday = self.calendar.component(.weekday, from: self.aTeusday)
                expect(weekday).to(be(3))
            }
            it("converts wednesday to 4") {
                let weekday = self.calendar.component(.weekday, from: self.aWednesday)
                expect(weekday).to(be(4))
            }
            it("converts thursday to 5") {
                let weekday = self.calendar.component(.weekday, from: self.aThursday)
                expect(weekday).to(be(5))
            }
            it("converts friday to 6") {
                let weekday = self.calendar.component(.weekday, from: self.aFriday)
                expect(weekday).to(be(6))
            }
            it("converts saturday to 7") {
                let weekday = self.calendar.component(.weekday, from: self.aSaturday)
                expect(weekday).to(be(7))
            }
        }
    }
}
