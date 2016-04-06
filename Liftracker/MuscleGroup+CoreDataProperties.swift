//
//  MuscleGroup+CoreDataProperties.swift
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

extension MuscleGroup {

    @NSManaged var name: String?
    @NSManaged var exercices: NSSet?

}
