//
//  LoggingUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import SwiftyBeaver
import os.log

// OS Log API
let appLogPrefix = "com.liftracker"
func logSystem(_ named: String) -> (String) -> OSLog {
    return { category in
        let system: String
        if named == "" {
            system = appLogPrefix
        } else {
            system = "\(appLogPrefix).\(named)"
        }
        return OSLog(subsystem: system, category: category)
    }
}

let appSystem = logSystem("")

// MARK :- shared system

let ui_log = appSystem("ui")
let data_log = appSystem("data")
let notification_log = appSystem("notifications")
