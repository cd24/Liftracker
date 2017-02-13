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
    override func execute(_ upgrade: Bool) {
        if upgrade { /* do upgrade things... perform a migration or something. */ }
        else { /* do first launch things */ }
    }
 }
 ```
 */
open class FirstLaunchAction: AppAction {
    let launchKey: Preference
    let upgradeKey: Preference
    
    public init() {
        let type = type(of: self)
        let appVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String)
        let marketingVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        launchKey = Preference("\(preferencePrefix).launch.\(type)")
        upgradeKey = Preference("\(preferencePrefix).upgrade.\(type).\(marketingVersion).\(appVersion)")
    }
    
    public func configuration() -> AppActionConfiguration {
        return .default
    }
    
    public func run(for type: EventType) {
        /// Only do stuff on launch
        let isUpgrade = !upgradeKey.bool() && launchKey.bool()
        if case type = EventType.launch,
           (!launchKey.bool() || !upgradeKey.bool()){
            execute( isUpgrade )
            launchKey.set( true )
            upgradeKey.set( true )
        }
    }
    
    /// Method to execute first launch action
    public func execute(_ upgrade: Bool) {
        
    }
}
