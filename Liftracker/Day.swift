//
//  Day.swift
//  Liftracker
//
//  Created by John McAvey on 1/14/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation

/**
 This representation provides a human-readable interaction with the schedule interface of the app. The raw value of this enum corosponds to the database representation used throughout the app.
 */
public enum Day: Int {
    case Sunday = 1
    case Monday = 2
    case Teusday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    
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
    public func nextOccurance(from date: Date = Date()) -> Date? {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .weekday, .weekOfYear], from: date)
        let weekday = components.weekday
        let daysToNext = ((7 + self.rawValue) - weekday!) % 7
        
        return calendar.date(byAdding: .day, value: daysToNext, to: date)
    }
}

extension Date {
    public func isDay(_ day: Day) -> Bool {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .weekday, .weekOfYear], from: self)
        let weekday = components.weekday
        return weekday == day.rawValue
    }
}
