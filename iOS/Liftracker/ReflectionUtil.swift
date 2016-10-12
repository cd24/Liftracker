//
//  ReflectionUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/8/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

/**
    This class provides a single location for reflection operations in the app.  Its primary purpose is to allow the app to pull in relevant data at runtime rather than having to register all components at compile time.
 */
class ReflectionUtil: BaseUtil {
    
    /**
        Retrieve all the class of the declared protocol.  Protocols being used for this MUST declare `@objc` to be used.  Otherwise, there will be a compile time error.
        
        @parameter p: The protocol to search for.  Must be an objective-c protocol
     
        @return - A list of classes which conform to the provided protocol
    */
    static func getImplementing(_ p: Protocol) -> [AnyClass] {
        
        log.verbose( "Retrieving classes of type \(p)" )
        let values = getAllClasses().filter({ class_conformsToProtocol($0, p)})
        log.verbose( "Retrieved \(values.count) classes of type \(p)" )
        return values
    }
    
    /**
        Retrieves all objective-c classes from the current application space.
     
        @return - A list containing all classes which extend NSObject or implement an Objective-C protocol
    */
    static func getAllClasses() -> [AnyClass] {
        let expectedCount = Int(objc_getClassList(nil, 0))
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: expectedCount)
        let autoreleasingPointer = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
        let actualCount: Int32 = objc_getClassList(autoreleasingPointer, Int32(expectedCount))
        
        
        
        return  (0..<actualCount).map({ index in
            if let curr: AnyClass = allClasses[Int(index)] {
                return curr
            }
            return nil
        })
            .filter({ (value: AnyClass?) -> Bool in
            return value != nil
        }) as! [AnyClass]
        
    }
}
