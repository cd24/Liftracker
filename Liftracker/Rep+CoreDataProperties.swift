//
//  Rep+CoreDataProperties.swift
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

extension Rep {

    @NSManaged var start_time: NSDate?
    @NSManaged var unit: String?
    @NSManaged var weight: NSNumber?

}
