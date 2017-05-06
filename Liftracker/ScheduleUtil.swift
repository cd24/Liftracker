//
//  ScheduleHelper.swift
//  Liftracker
//
//  Created by John McAvey on 9/18/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

class ScheduleUtil : BaseUtil {

    /**
     Attempts to return the next occurance of this date after
     the provided date.
     If retrieving the calendar or components fails, returns 
     today.
     
     - Parameters:
        - day: The day which the schedule is supposed to occur
        - fromDate: the base date - finds the next date after this field.  Defaults to now
     
     - Returns: the next occurance from the provided date.
     */
    static func getNextOccurance( day: Day, fromDate date: Date = Date() ) -> Date {
        
        if let calendar = NSCalendar(identifier: .gregorian) {
            let components = calendar.components([.year, .month, .weekday, .weekOfYear], from: date)
            let weekday = components.weekday
            let daysToNext = ((7 + day.rawValue) - weekday!) % 7

            return calendar.date(byAdding: .day, value: daysToNext, to: date, options: .init(rawValue: 0)) ?? Date()
        }
        
        return Date()
    }
    
    static func date(_ date: Date = Date(), is day: Day ) -> Bool {
        if let calendar = NSCalendar(identifier: .gregorian) {
            let components = calendar.components([.year, .month, .weekday, .weekOfYear], from: date)
            let weekday = components.weekday
            return weekday == day.rawValue
        }
        return false
    }
    
    static func active(on date: Date = Date(), _ schedule: UInt8) -> Bool {
        let current = NSCalendar.current.dateComponents([.weekday], from: date)
        guard let weekday = current.weekday else {
            log.error("Couldn't get weekday!")
            return false
        }
        let offset: UInt8 = (1 << UInt8(weekday - 1))
        let active = schedule & offset
        return active > 0
    }
    
    static func getDays(for schedule: UInt8) -> [Day] {
        var days: [Day] = []
        for i in 0..<8 {
            let offset: UInt8 = 1 << UInt8(i)
            let active = schedule & offset
            if active > 0,
                let day = Day(rawValue: i+1) {
                days.append( day )
            }
        }
        return days
    }
}

/**
 This representation provides a human-readable interaction with the schedule interface of the app.  The raw value of this enum corosponds to the database representation used throughout the app.
*/
enum Day: Int {
    
    case Sunday = 1
    case Monday = 2
    case Teusday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
}
