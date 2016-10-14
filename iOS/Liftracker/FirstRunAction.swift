//
//  FirstRunAction.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

/**
 This class provides a location where all first run actions can be added and managed.
*/
class LaunchActions {
    
    static var firstRunKey = "firstRun"
    static var shouldExecuteFirstRun: Bool = { () -> Bool in
        !UserDefaults.standard.bool(forKey: firstRunKey)
    }()
    
    /**
     executes items appropriate for the context.  First run items will be run if the first run key is not present in the user defaults, all other items will be run according to their description
    */
    static func execute() {
        
        log.info( "Executing first run items" )
        if let classes = ReflectionUtil.getImplementing( LaunchItem.self ) as? [LaunchItem.Type] {
            
            log.debug("Retrieved first launch items: \(classes)")
            
            for item in classes {
                
                log.debug("Creating instance of \(item)")
                let instance = item.init()
                log.debug("Created instance of \(item)")
                
                if instance.firstRunOnly() && !shouldExecuteFirstRun {
                    continue
                }
                
                if instance.syncronous?() ?? true {
                    log.verbose("Starting \(item) syncronously")
                    start(item: instance)
                } else {
                    let name = instance.queueName?() ?? UUID().uuidString
                    log.verbose("Starting \(item) asyncronously in queue named: \(name)")
                    start(item: instance, inQueueNamed: name)
                }
            }
        }
        log.info("Completed first run items")
        
        if shouldExecuteFirstRun {
            UserDefaults.standard.set(true, forKey: firstRunKey)
            shouldExecuteFirstRun = false
        }
    }
    
    static func start(item: LaunchItem, inQueueNamed name: String) {
        
        DispatchQueue(label: name).async {
            item.run()
        }
    }
    
    static func start(item: LaunchItem) {
        item.run()
    }

}

/**
 Describes an action take when the app launches.  Order is not constant.
 */
@objc protocol LaunchItem {
    
    /**
     Perform any preparation operations such as initialization
     */
    init()
    
    /**
     Perform any action which should be performed on first run
     */
    func run()
    
    /**
     Determines whether the action will be run only on first launch (true) or every time the app starts (false)
    */
    func firstRunOnly() -> Bool
    
    /**
     Controls whether the action should be performed syncronously or not.
     - Warning: The default is for the action to be syncronous.  If you have a long operation, implement this method and return true or the UI thread will lock on it.
     */
    @objc optional func syncronous() -> Bool
    
    /**
     Provides a name for the dispatch queue performing the operation if it's asyncronous.  Has no effect if syncronous does not return true.
     */
    @objc optional func queueName() -> String
}
