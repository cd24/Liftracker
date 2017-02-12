//
//  Session.swift
//  Liftracker
//
//  Created by John McAvey on 12/4/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import RealmSwift

class Session: Object {
    
    dynamic var timestamp = Date()
    var workout: Workout?
    var log = List<WorkoutSet>()
}
