//
//  WeightRep.swift
//  
//
//  Created by John McAvey on 4/6/16.
//
//

import Foundation
import CoreData

@objc(WeightRep)
class WeightRep: Rep {

// Insert code here to add functionality to your managed object subclass
    func getReps() -> Double {
        return self.reps!.doubleValue
    }
}
