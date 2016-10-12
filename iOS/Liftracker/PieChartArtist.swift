//
//  PieChartArtist.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit

/**
    Renders Sectioned data into a pie chart.  Requires SectionResult<Double>
 */
class PieChartArtist : Artist {
    
    required init() {
        
    }
    
    /**
        Renders the results as a pie chart
    
        - Parameters:
            - result: MUST be a SectionedResult<Double>, otherwise, an error is shown.
            - completion: callback to recieve the rendered view.
    */
    func render(result: AnalystResult, completion: (UIView?) -> Void) {
        
        if let pieResult = result as? SectionedResult<Double> {
            // TODO: render a pie chart and display the data.
            log.verbose("Processing pie chart data \(pieResult)")
            let view = renderPieChart(result: pieResult)
            
            if view == nil {
                log.warning( "Unable to render pie view with data: \(pieResult)" )
            }
            
            completion( view )
        } else {
            completion( nil )
        }
    }
    
    func renderPieChart( result: SectionedResult<Double> ) -> UIView? {
        return nil
    }
}
