//
//  Workout+CoreDataProperties.swift
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

extension Workout {

    @NSManaged var created: NSDate?
    @NSManaged var meta_data: NSSet?

}
