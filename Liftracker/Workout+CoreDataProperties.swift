//
//  Workout+CoreDataProperties.swift
//  
//
//  Created by John McAvey on 5/6/17.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var name: String?
    @NSManaged public var schedule: Int16
    @NSManaged public var model: NSOrderedSet?

}

// MARK: Generated accessors for model
extension Workout {

    @objc(insertObject:inModelAtIndex:)
    @NSManaged public func insertIntoModel(_ value: WorkoutSet, at idx: Int)

    @objc(removeObjectFromModelAtIndex:)
    @NSManaged public func removeFromModel(at idx: Int)

    @objc(insertModel:atIndexes:)
    @NSManaged public func insertIntoModel(_ values: [WorkoutSet], at indexes: NSIndexSet)

    @objc(removeModelAtIndexes:)
    @NSManaged public func removeFromModel(at indexes: NSIndexSet)

    @objc(replaceObjectInModelAtIndex:withObject:)
    @NSManaged public func replaceModel(at idx: Int, with value: WorkoutSet)

    @objc(replaceModelAtIndexes:withModel:)
    @NSManaged public func replaceModel(at indexes: NSIndexSet, with values: [WorkoutSet])

    @objc(addModelObject:)
    @NSManaged public func addToModel(_ value: WorkoutSet)

    @objc(removeModelObject:)
    @NSManaged public func removeFromModel(_ value: WorkoutSet)

    @objc(addModel:)
    @NSManaged public func addToModel(_ values: NSOrderedSet)

    @objc(removeModel:)
    @NSManaged public func removeFromModel(_ values: NSOrderedSet)

}
