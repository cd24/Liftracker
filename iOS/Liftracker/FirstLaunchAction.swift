//
//  FirstLaunchAction.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

/// Abstraction for a first launch action
open class FirstLaunchAction: AppAction {
    let launchKey: Preference
    
    public init() {
         launchKey = Preference("\(preferencePrefix).\(type(of: self))")
    }
    
    public func configuration() -> AppActionConfiguration {
        return .default
    }
    
    public func run(for type: EventType) {
        /// Only do stuff on launch
        if case type = EventType.launch,
            !launchKey.bool() {
            execute()
            launchKey.set( true )
        }
    }
    
    /// Method to execute first launch action
    public func execute() {
        
    }
}
