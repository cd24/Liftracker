//
//  SectionedResult.swift
//  Liftracker
//
//  Created by John McAvey on 10/11/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import os.log

class SectionedResult<T> : AnalystResult {
    
    var data: [ResultSection<T>]
		
    
    init(data: [ResultSection<T>]) {
        os_log("Creating section data",
               log: ui_log,
               type: .debug)
        os_log("Section data: %s",
               log: ui_log,
               type: .debug, "\(data)")
        self.data = data
    }
    
    override init() {
        os_log("Creating empty section data",
               log: ui_log,
               type: .debug)
        self.data = []
    }
    
    func sectionCount() -> Int {
        let count = data.count
        os_log("Current section count: %d",
               log: ui_log,
               type: .debug, count)
        return count
    }
    
    func data(forSection section: Int) -> ResultSection<T> {
        os_log("Retrieving value for sectioned data for section: %d",
               log: ui_log,
               type: .debug, section)
        
        if section > self.data.count {
            os_log("Attempted to access section %d which is out of bounds for data (%d)",
                   log: ui_log,
                   type: .error, section, self.data.count)
        }
        
        let res = data[section]
        
        return res
    }
}

struct ResultSection<T> {
    
    var data: T
    var label: String?
}
