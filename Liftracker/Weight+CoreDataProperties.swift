//
//  Weight+CoreDataProperties.swift
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

extension Weight {

    @NSManaged var date: NSDate?
    @NSManaged var notes: String?
    @NSManaged var published: NSNumber?
    @NSManaged var value: NSNumber?

}
