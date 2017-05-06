//
//  AppAction.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

/**
 App actions provide a mechanism for interacting with major lifecycle events without having to clutter the AppDelegate.
 Actions should be registered with the container class `ActionManager`
 */
public protocol AppAction {
    func configuration() -> AppActionConfiguration
    /**
     Execute the action for the given lifecycle event. Perform any work needed here. 
     - parameter type: the type of event being registered. See `EventType`
     */
    func run(for type: EventType)
}

/**
 Provides configuration information for an AppAction.
 */
public struct AppActionConfiguration {
    
    /**
     Standard configuration for an app Action. Contains the following configuration:
     - synchronous: false
    */
    static let `default` = AppActionConfiguration(syncronous: false)
    
    /// Determines whether or not the action will be run on the main thread
    let syncronous: Bool
}

/// An enumeration representing the possible invocation conditions for an AppAction
public enum EventType {
    /// Presented if this is the initial launch of the app. Equivilent to `func application(_ application:, didFinishLaunchingWithOptions:)`
    case launch( VersionChange? )
    /// Presented when the app resumes from the background.
    case resume
    /// Presented when the app is preparing to enter the background. Finish tasks here within 5 seconds, or start a background task to ensure the operation is not interrupted.
    case suspend
}
