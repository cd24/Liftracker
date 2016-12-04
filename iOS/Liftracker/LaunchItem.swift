//
//  LaunchItem.swift
//  Liftracker
//
//  Created by John McAvey on 12/4/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

/**
 Describes an action take when the app launches.  Order is not guaranteed.
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
    
    /**
     Return a set of conditions to be met before executing this action.
    */
    @objc optional func conditions() -> [LaunchCondition]
}
