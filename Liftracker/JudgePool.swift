//
//  JudgePool.swift
//  Liftracker
//
//  Created by John McAvey on 10/11/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import os.log

/**
    The judge pool provides an abstraction to preload all of the Judge classes at launch, and have them ready to be used when you need them.
*/
class JudgePool: NSObject {
    
    /**
     Singleton instance which is lazily loaded.
    */
    static let shared = JudgePool()
    
    private var judges: [String:Judge.Type]
    
    /**
    */
    override init() {
        self.judges = [:]
        super.init()
    }
    
    /**
        Attempts to retrieve a judge from the cache for the specified identifier.  Automatically casts the judge to the correct class.  To retrieve a judge of type T, use `let judge: T = getJudge(forIdentifier: T.identifier())`  The identifier and type must match.
        
     - parameter: forIdentifier: The string identifier of the judge to retrieve
     
     - Returns: A judge with a matching identifer and expected type or nil if the type/identifier are mismatched
    */
    func getJudge<T: Judge>(forIdentifier id: String) -> T? {
        os_log("Retrieving judge with identifier: %s",
               log: ui_log,
               type: .debug, id)
        let temp = self.judges
        let value = temp[id]
        
        if value == nil {
            os_log("No judge found with identifier: %s",
                   log: ui_log,
                   type: .info, id)
        } else {
            os_log("No judge found with identifier: %s",
                   log: ui_log,
                   type: .debug, id)
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
        os_log("Registering judge with identifier %s in judge pool",
               log: ui_log,
               type: .debug, type.identifier())
        
        if let oldTp = self.judges[type.identifier()] {
            os_log("Overwriting cached Judge type %s with type %s",
                   log: ui_log,
                   type: .info, "\(oldTp)", "\(type)")
        }
        self.judges[type.identifier()] = type
    }
}
