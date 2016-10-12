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
    
}

enum Day: Int {
    
    case Sunday = 1
    case Monday = 2
    case Teusday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
}
