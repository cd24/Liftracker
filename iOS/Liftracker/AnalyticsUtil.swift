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
        log.verbose("Analytics Util created ")
        log.debug("Analysts registered with utils: ")
        self.analysts.forEach() { log.debug( $0.getTitle() ) }
    }
    
    func retrieveAnalysts() {
        
        log.info("Retrieving analysts")
        var array = [Analyst]()
        if let analystClasses = ReflectionUtil.getImplementing( Analyst.self ) as? [Analyst.Type] {
            
            for analyst in analystClasses {
                
                log.debug("Retrieved analyst: \(analyst)")
                let instance: Analyst = analyst.init()
                log.debug("\(analyst) instantiated")
                array.append( instance )
            }
        }
        log.info("Finished retrieving analysts.")
        self.analysts = array
    }
}
