//
//  Rep.swift
//  
//
//  Created by John McAvey on 4/3/16.
//
//

import Foundation
import CoreData

@objc(Rep)
class Rep: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func getWeight() -> Double {
        return self.weight!.doubleValue
    }
}
