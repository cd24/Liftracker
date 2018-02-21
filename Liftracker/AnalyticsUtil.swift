//
//  AnalyticsUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import os.log

private let analytics_log = appSystem("analytics")

class AnalyticsUtil : BaseUtil {
    static let shared = AnalyticsUtil()
    public var analysts: [Analyst]
    
    override init() {
        os_log("Creating Analytics Util Instance",
               log: analytics_log,
               type: .info)
        self.analysts = []
        super.init()
        
    }
    
    func setup() {
        os_log("Analytics Util created",
               log: analytics_log,
               type: .info)
        os_log("Analysts registered with utils: ",
               log: analytics_log,
               type: .debug)
    }
}
