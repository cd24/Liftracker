//
//  Set.swift
//  Liftracker
//
//  Created by John McAvey on 12/4/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import RealmSwift

class WorkoutSet: Object {
    
    dynamic var timestamp = Date()
    dynamic var target: Double = 0
    dynamic var count: Double = 0
    dynamic var weight: Float = 0
    
    var exercice: Exercice?
}
