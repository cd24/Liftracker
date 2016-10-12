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
    
    var analysts: [Analyst]
    
    override init() {
        log.verbose("Creating Analytics Util Instance")
        self.analysts = []
        super.init()
        
    }
    
    func setup() {
        retrieveAnalysts()
        log.info("Analytics Util created with Analysts: ")
        self.analysts.forEach() { log.info( $0.getTitle() ) }
    }
    
    func retrieveAnalysts() {
        
        var array = [Analyst]()
        if let analystClasses = ReflectionUtil.getImplementing( Analyst.self ) as? [Analyst.Type] {
            
            for analyst in analystClasses {
                
                let instance: Analyst = analyst.init()
                array.append( instance )
            }
        }
        
        self.analysts = array
    }
}
