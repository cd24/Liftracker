//
//  SectionedResult.swift
//  Liftracker
//
//  Created by John McAvey on 10/11/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

class SectionedResult<T> : AnalystResult {
    
    var data: [Section<T>]
		
    
    init(data: [Section<T>]) {
        log.verbose("Creating section data")
        log.debug("Section Data: \(data)")
        self.data = data
    }
    
    override init() {
        log.verbose("Creating empty section data")
        self.data = []
    }
    
    func sectionCount() -> Int {
        let count = data.count
        log.debug("Current section count: \(count)")
        return count
    }
    
    func data(forSection section: Int) -> Section<T> {
        
        log.debug( "Retrieving value for sectioned data for section \(section)" )
        
        if section > self.data.count {
            log.error("Attempted to access section \(section) which is out of bounds for data (\(self.data.count))s")
        }
        
        let res = data[section]
        
        return res
    }
}

struct Section<T> {
    
    var data: T
    var label: String?
}
