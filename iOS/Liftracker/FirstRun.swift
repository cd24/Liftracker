//
//  FirstRun.swift
//  Liftracker
//
//  Created by John McAvey on 12/4/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit

class FirstRunCondition : LaunchCondition {
    
    let key = "firstRun"
    
    func satisfied() -> Bool {
        
        return !UserDefaults.standard.bool(forKey: key)
    }
}
