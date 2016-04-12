//
//  TimedRep.swift
//  
//
//  Created by John McAvey on 4/6/16.
//
//

import Foundation
import CoreData

@objc(TimedRep)
class TimedRep: Rep {

// Insert code here to add functionality to your managed object subclass
    func getTimeString() -> String{
        let duration = TimeManager.getDuration(self.start_time!, end: self.end_time!)
        return String(format: "%02d:%02d:%02d", duration.hour, duration.minute, duration.second)
    }
}
