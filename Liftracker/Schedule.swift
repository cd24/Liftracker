//
//  Schedule.swift
//  Liftracker
//
//  Created by John McAvey on 2/26/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

class Schedule {
    let days: [Day]
    
    init() {
        days = []
    }
    
    init(byte: UInt8) {
        var days: [Day] = []
        for i in 0..<8 {
            let offset: UInt8 = 1 << UInt8(i)
            let active = byte & offset
            if active > 0,
                let day = Day(rawValue: i+1) {
                days.append( day )
            }
        }
        self.days = days
    }
    
    // Convinience for hydrating from database
    convenience init(num: Int16) {
        self.init(byte: UInt8(num))
    }
    
    public func asByte() -> UInt8 {
        var br: UInt8 = 0
        for day in days {
            let flag: UInt8 = UInt8(1) << UInt8(day.rawValue)
            br = br | flag
        }
        return br
    }
    
    public func active(on date: Date = Date()) -> Bool {
        return self.days.reduce(false) { accum, next in
            return accum || date.isDay(next)
        }
    }
}
