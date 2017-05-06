//
//  Rep+CoreDataProperties.swift
//  
//
//  Created by John McAvey on 5/6/17.
//
//

import Foundation
import CoreData


extension Rep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rep> {
        return NSFetchRequest<Rep>(entityName: "Rep")
    }

    @NSManaged public var count: Double
    @NSManaged public var datePerformed: NSDate?
    @NSManaged public var duration: Double
    @NSManaged public var exercice: Exercice?

}
