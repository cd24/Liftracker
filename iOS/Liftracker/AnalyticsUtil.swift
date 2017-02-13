//
//  AnalyticsUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

class AnalyticsUtil : BaseUtil {
    
    static let shared = AnalyticsUtil()
    
    public var analysts: [Analyst]
    
    override init() {
        log.verbose("Creating Analytics Util Instance")
        self.analysts = []
        super.init()
        
    }
    
    func setup() {
        log.verbose("Analytics Util created ")
        log.debug("Analysts registered with utils: ")
    }
}
