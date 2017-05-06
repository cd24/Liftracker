//
//  Set+CoreDataProperties.swift
//  
//
//  Created by John McAvey on 5/6/17.
//
//

import Foundation
import CoreData


extension Set {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    @NSManaged public var time: NSDate?
    @NSManaged public var exerice: Exercice?
    @NSManaged public var reps: NSSet?
    @NSManaged public var target: WorkoutSet?

}

// MARK: Generated accessors for reps
extension Set {

    @objc(addRepsObject:)
    @NSManaged public func addToReps(_ value: Rep)

    @objc(removeRepsObject:)
    @NSManaged public func removeFromReps(_ value: Rep)

    @objc(addReps:)
    @NSManaged public func addToReps(_ values: NSSet)

    @objc(removeReps:)
    @NSManaged public func removeFromReps(_ values: NSSet)

}
