//
//  Session+CoreDataProperties.swift
//  
//
//  Created by John McAvey on 5/6/17.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var time: NSDate?
    @NSManaged public var log: NSOrderedSet?
    @NSManaged public var workout: Workout?

}

// MARK: Generated accessors for log
extension Session {

    @objc(insertObject:inLogAtIndex:)
    @NSManaged public func insertIntoLog(_ value: Set, at idx: Int)

    @objc(removeObjectFromLogAtIndex:)
    @NSManaged public func removeFromLog(at idx: Int)

    @objc(insertLog:atIndexes:)
    @NSManaged public func insertIntoLog(_ values: [Set], at indexes: NSIndexSet)

    @objc(removeLogAtIndexes:)
    @NSManaged public func removeFromLog(at indexes: NSIndexSet)

    @objc(replaceObjectInLogAtIndex:withObject:)
    @NSManaged public func replaceLog(at idx: Int, with value: Set)

    @objc(replaceLogAtIndexes:withLog:)
    @NSManaged public func replaceLog(at indexes: NSIndexSet, with values: [Set])

    @objc(addLogObject:)
    @NSManaged public func addToLog(_ value: Set)

    @objc(removeLogObject:)
    @NSManaged public func removeFromLog(_ value: Set)

    @objc(addLog:)
    @NSManaged public func addToLog(_ values: NSOrderedSet)

    @objc(removeLog:)
    @NSManaged public func removeFromLog(_ values: NSOrderedSet)

}
