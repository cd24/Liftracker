//
//  WorkoutMetaData+CoreDataProperties.swift
//  
//
//  Created by John McAvey on 4/3/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WorkoutMetaData {

    @NSManaged var duration_hour: NSNumber?
    @NSManaged var duration_minute: NSNumber?
    @NSManaged var duration_second: NSNumber?
    @NSManaged var target_reps: NSNumber?
    @NSManaged var workout: Workout?

}
