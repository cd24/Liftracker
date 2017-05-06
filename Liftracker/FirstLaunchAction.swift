//
//  FirstLaunchAction.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

/**
 Abstraction for a first launch action. These actions generate their own preferences based on the class name. 
 Preference name structure for launch: <preference prefix>.launch.<class type name>
 Preference name structure for upgrade: <preference prefix>.upgrade.<class type name>.<bundle number>
 
 First launch actions will only run once per installation. They will be invoked when a new version of the app is installed and the upgrade flag in execute will be set to true.
 
 These actions use the default configuration.
 
 Example
 ```
 class SetDefaults: FirstLaunchAction {
    override func execute(_ upgrade: VersionChange?) {
        if let change = upgrade { /* do upgrade things... perform a migration or something. */ }
        else { /* do first launch things */ }
    }
 }
 ```
 */
open class FirstLaunchAction: AppAction {
    let launchKey: Preference
    
    public init() {
        let type = type(of: self)
        launchKey = Preference("\(preferencePrefix).launch.\(type)")
    }
    
    public func configuration() -> AppActionConfiguration {
        return .default
    }
    
    public func run(for type: EventType) {
        
        switch type {
        case .launch( let change ):
            if !launchKey.bool() || change != nil {
                execute( change )
                launchKey.set( true )
            }
        default:
            return
        }
    }
    
    /// Method to execute first launch action
    public func execute(_ upgrade: VersionChange?) {
        
    }
}
