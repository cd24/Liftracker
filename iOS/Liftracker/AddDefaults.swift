//
//  AddDefaults.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

class AddDefaults: LaunchItem {
    
    required init() {
        
    }
    
    func run() {
        log.info("Adding default items")
        log.verbose("Adding default workouts")
        
        // WorkoutHelper.addDefaultWorkouts()
        
        log.info("Completed adding defaults")
    }
    
    func firstRunOnly() -> Bool {
        return true
    }
    
    func syncronous() -> Bool {
        return true
    }
}
