//
//  GroupAnalyst.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import PromiseKit

class GroupAnalyst : Analyst {
    
    required init() {
        
    }
    
    func analyze() -> Promise<AnalystResult> {
        return Promise { fufill, reject in
            reject(AnalystError.generic)
        }
    }
    
    func interrupt() {
        
    }
    
    func getArtist() -> Artist {
        return PieChartArtist()
    }
    
    
    func getTitle() -> String {
        return "Muscle Group Breakdown"
    }
    
    func getDescription() -> String {
        return "Shows a radar chart of the time spent on each Muscle Group.  The score is relative to other groups."
    }
}
