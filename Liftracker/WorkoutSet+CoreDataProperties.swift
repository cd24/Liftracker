//
//  WorkoutSet+CoreDataProperties.swift
//  
//
//  Created by John McAvey on 5/6/17.
//
//

import Foundation
import CoreData


extension WorkoutSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutSet> {
        return NSFetchRequest<WorkoutSet>(entityName: "WorkoutSet")
    }

    @NSManaged public var target_reps: Double
    @NSManaged public var target_time: Double
    @NSManaged public var weight: Float
    @NSManaged public var exercice: Exercice?

}
