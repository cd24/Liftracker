//
//  TimedRep.swift
//  
//
//  Created by John McAvey on 4/3/16.
//
//

import Foundation
import CoreData

@objc(TimedRep)
class TimedRep: Rep {
    let numberFormatter = NSNumberFormatter()
    var formatterConfigured: Bool = false
    
    func getTimeString() -> String {
        if !formatterConfigured {
            setupFormatter()
        }
        
        let elapsed = TimeManager.getDuration(start_time!, end: end_time!)
        
        let hr = numberFormatter.stringFromNumber(elapsed.hour)!
        let min = numberFormatter.stringFromNumber(elapsed.minute)!
        let sec = numberFormatter.stringFromNumber(elapsed.second)!
        
        return "\(hr):\(min):\(sec),\tWeight: \(weight!.doubleValue)"
    }
    
    private func setupFormatter() {
        numberFormatter.paddingPosition = NSNumberFormatterPadPosition.BeforePrefix
        numberFormatter.paddingCharacter = "0"
        numberFormatter.minimumIntegerDigits = 2
        
        formatterConfigured = true
    }
}
