//
//  Workout.swift
//  Liftracker
//
//  Created by John McAvey on 12/4/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import RealmSwift

class Workout: Object {
    
    dynamic var name = ""
    dynamic var schedule: Int8 = 0
    
    var model = List<WorkoutSet>()
}
