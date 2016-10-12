//
//  PieChartArtist.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit

class PieChartArtist : Artist {
    
    required init() {
        
    }
    
    func render(result: AnalystResult, completion: (UIView?) -> Void) {
        
        if let pieResult = result as? PieChartAnalyticData {
            // TODO: render a pie chart and display the data.
            log.verbose("Processing pie chart data \(pieResult)")
            completion(nil)
        } else {
            completion(nil)
        }
    }
}

@objc protocol PieChartAnalyticData {
    
    func numberOfSections() -> Int
    func value(forSection section: Int)
    
    @objc optional func title(forSection: Int) -> String
    @objc optional func showPercent() -> Bool
    @objc optional func showValue() -> Bool
}
