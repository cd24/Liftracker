//
//  LoggingUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import SwiftyBeaver

// Defines the log level for the application.  This reduces the cost at compile time by transforming logging calls from buffer outputs to empty methods.  This prevents the need for a runtime check on logging - minisucle, but non-zero savings :)

/**
    Right now, this class acts as a wrapper on SwiftBeaver.  It forwards messages and setups accordingly. 
    However, this class provides an abstraction to logging which will allow us to hotswap any logging utility
 
    Control logging using the compiler flags.  You MUST include each flag you want to consider.  This simplifies the logic in this class.  This means that you can control exactly what logs you want output, rather than having a level.  
 
    - Active Compilation Conditions:
        - VEBOSE:  Verbose logging
        - DEBUG:   Debug logging
        - INFO:    Info logging
        - ERROR:   Error logging
        - WARNING: Warning logging
 */
class LoggingUtil : BaseUtil, Logger {
    
    /**
     Current logger.  The behaviour of modifying at runtime after inital configuration through `setup()` or `configure()` is undefined.
    */
    private static var logger: Logger.Type = ConsoleLogger.self
    
    /**
        If you don't have a custom logger you want to use, invoke this method.  It will send all logs through NSLog.
        - Warning: The behaviour of modifying at runtime after inital configuration through `setup()` or `configure()` is undefined.
    */
    static func configure() {
        self.setup( ConsoleLogger.self )
    }
    
    /**
        A convinience method to configure a logging utility.  Passing a `Logger` type to this method will configure that logger as the default for the static context of this class.  
        - Warning: Overwrites the existing logger
        - Warning: The behaviour of modifying at runtime after inital configuration through `setup()` or `configure()` is undefined.
    */
    static func setup(_ logger: Logger.Type ) {
        
        logger.configure()
        LoggingUtil.logger = logger
        LoggingUtil.verbose("Logger '\(logger)' Configured")
    }
    
    /**
     An verbose log statement.  Passes to the specified `Logger` instance, iff the `VERBOSE` condition is set in
     */
    static func verbose(_ message: Any) {
        #if VERBOSE
            logger.verbose( message )
        #else
        #endif
    }
    
    /**
     An warning log statement.  Passes to the specified `Logger` instance, iff the `WARNING` condition is set in
     */
    static func warning(_ message: Any) {
        #if WARNING
            if let implementation = logger.warning {
                implementation(message)
            } else {
                verbose( message )
            }
        #else
        #endif
    }
    
    /**
     An error log statement.  Passes to the specified `Logger` instance, iff the `ERROR` condition is set in
     */
    static func error(_ message: Any) {
        #if ERROR
            if let implementation = logger.error {
                implementation(message)
            } else {
                verbose( message )
            }
        #else
        #endif
    }
    
    /**
     An info log statement.  Passes to the specified `Logger` instance, iff the `INFO` condition is set in
     */
    static func info(_ message: Any) {
        #if INFO
            if let implementation = logger.info {
                implementation(message)
            } else {
                verbose( message )
            }
        #else
        #endif
    }
    
    /**
     A debug log statement.  Passes to the specified `Logger` instance, iff the `DEBUG` condition is set in
     */
    static func debug(_ message: Any) {
        #if DEBUG
            if let implementation = logger.debug {
                implementation(message)
            } else {
                verbose( message )
            }
        #else
        #endif
    }
    
    static func WTF(_ message: Any) {
        
        log.error( "WTF" )
        log.error( message )
    }
}

/**
    A basic logger which passes all input to NSLog without any formatting or colour.
 */
class ConsoleLogger: Logger {
    
    /**
     This method exists only to conform to the Logger protocol.
    */
    static func configure() {
        //NSLog doesn't require any configuration
    }
    
    /**
     Forwarding method to NSLog.  Wraps the argument in a string using Swift insertion ("\(X)")
    */
    static func verbose(_ message: Any) {
        NSLog("\(message)")
    }
}

/**
    Defines the outline of a logging utility that provides an implementation independent interface to work within the app.  This abstraction allows swapping of logging libraries with little effort.
    If any optional method is unimplemented, the verbose method will be used in its stead.
 */
@objc protocol Logger {
    
    /**
     Perform any setup before logging.  This method will be blocking, so this should be a fast.
    */
    static func configure()
    
    /**
     Verbose logging - outputs when the VERBOSE condition is present.  Used as a default for any other optional methods which are missing.
     */
    static func verbose(_ message: Any)
    
    /**
     Warnings which the developer may want to know about, but are not fatal to the library or application.
    */
    @objc optional static func warning(_ message: Any)
    
    /**
     Errors are anything which is fatal to the context.  Should provide as much detail as possible about the cause of the failure.
    */
    @objc optional static func error(_ message: Any)
    /**
     Information is anything that would be useful for observing the lifecycle of your context, but does not contain any information specific about the execution (e.g. "<My Plugin> loaded", "<My Plugin> started processing"...etc)
    */
    @objc optional static func info(_ message: Any)
    
    /**
     Contains information specific to the execution state, this can be data that's being manipulated, current operations, or any other log representing state that doesn't fall into the Warning or Error categories.
    */
    @objc optional static func debug(_ message: Any)
    
    /**
     Credit - Google.  What a Terrible Failure logs are for points that should be impossible to reach.  Anywhere you would put "shouldn't happen", use a WTF log with more info.  The LoggingUtil will prepend "WTF" to the resulting error log
    */
    @objc optional static func WTF(_ message: Any)
}

// Declare the logging instance in the global scope.  Allows it to be used anywhere.
let log = LoggingUtil.self
