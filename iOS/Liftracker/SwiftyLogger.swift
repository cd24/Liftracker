//
//  SwiftyLogger.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import SwiftyBeaver

/**
 An implementation of the Logger class for SwiftyBeaver.  Logs to console on debug, and logs to file on release.
*/
class SwiftyLogger : Logger {
    
    static func configure() {
        let documentsPath = FileUtil.getDocumentDirectory()
        
        // Don't bother writing to file if it's a debug build
        #if DEBUG
            
            let console = ConsoleDestination()
            setFormat(dest: console)
            SwiftyBeaver.addDestination(console)
            SwiftyBeaver.info("Debug Logging Setup")
            
        // Otherwise preserve the logs in a file.
        #else
            
            let logFile = "Liftracker.log"
            let file = FileDestination()
            file.logFileURL = documentsPath.appendingPathComponent(logFile, isDirectory: false)
            setFormat(dest: file)
            SwiftyBeaver.addDestination(file)
            SwiftyBeaver.info("Release Logging Setup")
            
        #endif
    }
    
    private static func setFormat(dest: BaseDestination) {
        
        dest.format = "[$Dhh:mm:ss MM:dd:yyyy$d | $N.$F:$l] $M"
    }
    
    static func verbose(_ message: Any) {
        SwiftyBeaver.verbose( message )
    }
    
    static func warning(_ message: Any) {
        SwiftyBeaver.warning( message )
    }
    
    static func error(_ message: Any) {
        SwiftyBeaver.error( message )
    }
    
    static func info(_ message: Any) {
        SwiftyBeaver.info( message )
    }
    
    static func debug(_ message: Any) {
        SwiftyBeaver.debug( message )
    }
}
