//
//  FirstRunAction.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit

/**
 This class provides a location where all first run actions can be added and managed.
*/
class LaunchActions {
    
    static let shared = LaunchActions()
    
    private let firstRunKey: String
    private var firstRun: Bool
    private var items: [LaunchItem.Type]? = nil
    
    init(key: String = "firstRun") {
        // Configure listeners
        self.firstRunKey = key
        self.firstRun = !UserDefaults.standard.bool(forKey: firstRunKey)
    }
    
    func configure() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: self,
                                               queue: nil,
                                               using: {_ in
                                                
                                                self.execute()
        })
    }
    
    /**
     executes items appropriate for the context.  First run items will be run if the first run key is not present in the user defaults, all other items will be run according to their description
    */
    func execute() {
        
        log.info( "Executing first run items" )
        if let classes = getLaunchItems() {
            
            for item in classes {
                
                log.debug("Creating instance of \(item)")
                let instance = item.init()
                log.debug("Created instance of \(item)")
                
                if !conditionsMet( for: instance ) {
                    log.verbose("Conditions not met for \(type(of: instance)), continuing")
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
        
        log.info("Completed launch items")
        
        if self.firstRun {
            UserDefaults.standard.set(true, forKey: firstRunKey)
            self.firstRun = false
        }
    }
    
    func start(item: LaunchItem, inQueueNamed name: String) {
        
        DispatchQueue(label: name).async {
            item.run()
        }
    }
    
    func start(item: LaunchItem) {
        item.run()
    }
    
    func getLaunchItems() -> [LaunchItem.Type]? {
        
        if let actions = self.items {
            return actions
        }
        
        self.items = ReflectionUtil.getImplementing( LaunchItem.self ) as? [LaunchItem.Type]
        log.debug("Retrieved first launch items: \(self.items)")
        
        return self.items
    }
    
    func conditionsMet(for action: LaunchItem) -> Bool {
        
        return (action.conditions?() ?? []).reduce(true) { $0 ? $1.satisfied() : false }
    }
}

