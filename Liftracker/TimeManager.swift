//
//  TimeManager.swift
//  Liftracker
//
//  Created by John McAvey on 1/9/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import Foundation
import UIKit

//This class contains helper methods to do fun stuff with time.  
class TimeManager {
    //travels steps days in time (negative to go back in time).  Defualts to days, but can be adjusted by added an NSCalendarUnit to the component parameter.
    static func timeTravel(steps step: Int, base: NSDate, component: NSCalendarUnit = NSCalendarUnit.Day) -> NSDate {
        let calendar = getCalendar()
        let components = NSDateComponents()
        components.setValue(step, forComponent: component)
        return calendar.dateByAddingComponents(components, toDate: base, options: NSCalendarOptions(rawValue: 0))!
    }
    
    static func startOfDay(date: NSDate) -> NSDate{
        let calendar = getCalendar()
        let startOfDay = calendar.startOfDayForDate(date)
        return zeroDateTime(startOfDay)
    }
    
    static func startOfWeek(date: NSDate) -> NSDate {
        let calendar = getCalendar()
        let components = calendar.components([.YearForWeekOfYear, .WeekOfYear], fromDate: date)
        return calendar.dateFromComponents(components)!
    }
    
    static func startOfMonth(date: NSDate) -> NSDate{
        let calendar = getCalendar()
        let components = calendar.components([.Month], fromDate: date)
        return calendar.dateFromComponents(components)!
    }
    
    static func startOfYear(date: NSDate) -> NSDate{
        let calendar = getCalendar()
        let components = calendar.components([.Year], fromDate: date)
        return calendar.dateFromComponents(components)!
    }
    
    static func endOfDay(date: NSDate) -> NSDate {
        let calendar = getCalendar()
        let startOfTomorrow = calendar.startOfDayForDate(timeTravel(steps: 1, base: date))
        let components = NSDateComponents()
        components.setValue(-1, forComponent: NSCalendarUnit.Second)
        return calendar.dateByAddingComponents(components,
            toDate: startOfTomorrow,
            options: NSCalendarOptions(rawValue: 0))!
    }
    
    static func endOfWeek(date: NSDate) -> NSDate {
        return timeTravel(steps:6,
            base: startOfWeek(date))
    }
    
    static func endOfMonth(date: NSDate) -> NSDate {
        let calendar = getCalendar()
        let daysInMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length - 1
        return timeTravel(steps: daysInMonth,
            base: startOfMonth(date))
    }
    
    static func endOfYear(date: NSDate) -> NSDate{
        let calendar = getCalendar()
        let daysInYear = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Year, forDate: date).length - 1
        return timeTravel(steps: daysInYear, base: startOfMonth(date))
    }
    
    static func getDayOfWeek() -> NSDate {
        return startOfDay(NSDate())
    }
    
    static func dateToString(date: NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("ddMMMyyyy", options: 0, locale: NSLocale.systemLocale())
        formatter.timeZone = NSTimeZone.systemTimeZone()
        return formatter.stringFromDate(date)
    }
    
    static func dateToStringWithTime(date: NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("ddMMyyyy hh:mm", options: 0, locale: NSLocale.systemLocale())
        formatter.timeZone = NSTimeZone.systemTimeZone()
        return formatter.stringFromDate(date)
    }
    
    static func zeroDateTime(date: NSDate) -> NSDate {
        let calendar = getCalendar()
        return calendar.dateBySettingHour(0,
            minute: 0,
            second: 0,
            ofDate: date,
            options: NSCalendarOptions(rawValue: 0))!
    }
    
    static func getCalendar() -> NSCalendar {
        return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    }
    
    static func getDuration(start: NSDate, end: NSDate) -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        let calendar = getCalendar()
        let unitFlags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(unitFlags,
                                    fromDate: start,
                                    toDate: end,
                                    options: NSCalendarOptions(rawValue: 0))
        return (components.year, components.month, components.day, components.hour, components.minute, components.second)
    }
}
