//
//  Set.swift
//  Liftracker
//
//  Created by John McAvey on 5/13/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import RealmSwift

public class WorkoutSet: Object {
    public var exercice: Exercice? = nil
    public var reps: List<Rep> = List()
    public var target: WorkoutSet? = nil
    public var time: Double = 0
}
