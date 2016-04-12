//
//  Exercice+CoreDataProperties.swift
//  
//
//  Created by John McAvey on 4/6/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Exercice {

    @NSManaged var best: NSNumber?
    @NSManaged var isTimed: NSNumber?
    @NSManaged var name: String?
    @NSManaged var muscle_group: MuscleGroup?
    @NSManaged var timed_reps: NSSet?
    @NSManaged var weighted_reps: NSSet?
    @NSManaged var workouts: NSSet?

}
