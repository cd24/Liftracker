//
//  JudgePool.swift
//  Liftracker
//
//  Created by John McAvey on 10/11/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

/**
    The judge pool provides an abstraction to preload all of the Judge classes at launch, and have them ready to be used when you need them.
*/
class JudgePool: NSObject {
    
    /**
     Singleton instance which is lazily loaded.  Each time the class is instantiated it reloads all the Judge classes in the current execution context.  This is non-trivially expensive (O(n) best case on the number of classes in the project).  To minimize this cost, perform this operation once the first time it's needed.  
    */
    static let shared = JudgePool()
    
    private var judges: [String:Judge.Type]
    
    /**
        Uses reflection to gather all the Judge classes available in the running project.
    */
    override init() {
        self.judges = [:]
        super.init()
        
        log.info("Creating Judge cache.")
        log.verbose("Retrieving Judge classes")
        
        let foundClasses = ReflectionUtil.getImplementing( Judge.self )
        
        if let classes = foundClasses as? [Judge.Type] {
            
            log.verbose("Retrieved Judge Classes")
            log.debug("Retrieved \(classes.count) judges")
            log.debug("Judges: \(classes)")
            
            classes.forEach() { judge in
                judges[judge.identifier()] = judge
            }
            
        } else {
            log.error("Failed to retrieve judge classes")
            log.error("Judge classes found were the wrong type: \(foundClasses)")
        }
    }
    
    /**
        Attempts to retrieve a judge from the cache for the specified identifier.  Automatically casts the judge to the correct class.  To retrieve a judge of type T, use `let judge: T = getJudge(forIdentifier: T.identifier())`  The identifier and type must match.
        
     - parameter: forIdentifier: The string identifier of the judge to retrieve
     
     - Returns: A judge with a matching identifer and expected type or nil if the type/identifier are mismatched
    */
    func getJudge<T: Judge>(forIdentifier id: String) -> T? {
        log.info("Retrieving Judge")
        log.debug("Retrieving judge with identifier: \(id)")
        let temp = self.judges
        let value = temp[id]
        
        if value == nil {
            log.warning("No judge found with identifier: \(id)")
        } else {
            log.debug("Retrieved judge with identifier: \(id)")
        }
        
        return value?.init() as? T
    }
    
    /**
        Registers a the type of a provided Judge object.  If you would like to register just the class type, use `register(type:)`
    */
    func register(judge: Judge) {
        let cls = type(of: judge)
        register(type: cls)
    }
    
    /**
        Registers the provided type to the judges pool
        - Warning: This operation will overwrite existing judge pool entries with the same identifier.
    */
    func register(type: Judge.Type) {
        log.debug("Registering judge with identifier '\(type.identifier())' in judge pool")
        
        if let oldTp = self.judges[type.identifier()] {
            log.warning("Overwriting cached Judge type '\(oldTp)' with type '\(type)'")
        }
        self.judges[type.identifier()] = type
    }
}
