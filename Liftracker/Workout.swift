//
//  Workout.swift
//  Liftracker
//
//  Created by John McAvey on 5/13/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import RealmSwift

public class Workout: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var schedule: Int = 0b00000000
    var model: List<WorkoutSet> = List()
    
    func getSchedule() -> Schedule {
        return Schedule(self.schedule.byte())
    }
}
