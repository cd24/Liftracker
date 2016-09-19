//
//  ScheduleHelper.swift
//  Liftracker
//
//  Created by John McAvey on 9/18/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

class ScheduleHelper {

    
    // Attempts to return the next occurance of this date after
    // the provided date.
    // If retrieving the calendar or components fails, returns 
    // today.
    static func getNextOccurance( day: Day, fromDate date: Date = Date() ) -> Date {
        
        if let calendar = NSCalendar(identifier: .gregorian) {
            let components = calendar.components([.year, .month, .weekday, .weekOfYear], from: date)
            let weekday = components.weekday
            let daysToNext = ((7 + day.rawValue) - weekday!) % 7

            return calendar.date(byAdding: .day, value: daysToNext, to: date, options: .init(rawValue: 0)) ?? Date()
        }
//        if let today_calendar = calendar?.component(.weekday, from: date) {
//            
//            if let today = Day.fromDayComponent(component: today_calendar) {
//                
//                let daysToTravel = day.rawValue - today.rawValue
//                var daysComponent = DateComponents()
//                daysComponent.day = 0
//                daysComponent.month = 0
//                daysComponent.year = 0
//            
//                if daysToTravel > 0 {
//                    daysComponent.day = daysToTravel
//                } else {
//                    let toWeekEnd = Day.Saturday.rawValue - day.rawValue
//                
//                    
//                    // Jump to the weekend, then to the next time this day occurs
//                    daysComponent.day = toWeekEnd + day.rawValue
//                }
//            
//                return calendar?
//                    .date(byAdding: daysComponent, to: date, options: .init(rawValue: 0))
//                    ?? Date()
//            }
//        }
        
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
    
    static func fromDayComponent(component: Int) -> Day? {
        
        switch component {
        case CalendarDays.Sunday.rawValue:
            return .Sunday
        case CalendarDays.Monday.rawValue:
            return .Monday
        case CalendarDays.Teusday.rawValue:
            return .Teusday
        case CalendarDays.Wednesday.rawValue:
            return .Wednesday
        case CalendarDays.Thursday.rawValue:
            return .Thursday
        case CalendarDays.Friday.rawValue:
            return .Friday
        case CalendarDays.Saturday.rawValue:
            return .Saturday
        default:
            NSLog("Unkown weekday: \(component)")
            return nil
        }
    }
    
    func toDayComponent() -> CalendarDays {
        
        switch self {
        case .Sunday:
            return .Sunday
        case .Monday:
            return .Monday
        case .Teusday:
            return .Teusday
        case .Wednesday:
            return .Wednesday
        case .Thursday:
            return .Thursday
        case .Friday:
            return .Friday
        case .Saturday:
            return .Saturday
        }
    }
}

enum CalendarDays : Int {
    
    case Sunday = 4
    case Monday = 3
    case Teusday = 2
    case Wednesday = 1
    case Thursday = 7
    case Friday = 6
    case Saturday = 5
}
