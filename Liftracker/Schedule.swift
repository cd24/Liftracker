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
        days = ScheduleUtil.getDays(for: byte)
    }
    
    func asByte() -> UInt8 {
        var br: UInt8 = 0
        for day in days {
            let flag: UInt8 = UInt8(1) << UInt8(day.rawValue)
            br = br | flag
        }
        return br
    }
}
