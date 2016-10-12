//
//  LoggingUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import SwiftyBeaver

class LoggingUtil : BaseUtil {
    
    static let logFile = "Liftracker.log"
    
    static func configure() {
        
        let documentsPath = FileUtil.getDocumentDirectory()
        
        let console = ConsoleDestination()
        let file = FileDestination()
        
        file.logFileURL = documentsPath.appendingPathComponent(logFile, isDirectory: false)
        setFormat(dest: console)
        setFormat(dest: file)
        
        SwiftyBeaver.addDestination(console)
        SwiftyBeaver.addDestination(file)
        
        log.info("Logging setup")
    }
    
    static func setFormat(dest: BaseDestination) {
        
        dest.format = "[$Dhh:mm:ss MM:dd:yyyy$d | $N.$F:$l] $M"
    }
}

// Declare the logging instance in the global scope.  Allows it to be used anywhere.
let log = SwiftyBeaver.self
