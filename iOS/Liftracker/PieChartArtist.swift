//
//  PieChartArtist.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

/**
    Renders Sectioned data into a pie chart.  Requires SectionResult<Double>
 */
class PieChartArtist : Artist {
    
    required init() {
        log.verbose("Initalized a PieChartArtist")
    }
    
    /**
        Renders the results as a pie chart
    
        - Parameters:
            - result: MUST be a SectionedResult<Double>, otherwise, an error is shown.
    */
    func render(result: AnalystResult) -> Promise<UIView> {
        return Promise { fufill, reject in
            log.verbose("Rendering pie chart view")
            log.debug("Rendering from \(result)")
            
            if let pieResult = result as? SectionedResult<Double> {
                // TODO: render a pie chart and display the data.
                log.verbose("Processing pie chart data \(pieResult)")
                if let view = renderPieChart(result: pieResult) {
                    fufill( view )
                } else {
                    log.warning( "Unable to render pie view with data: \(pieResult)" )
                    reject( ArtistError.generic )
                }
            } else {
                reject( ArtistError.unkownData )
            }
        }
    }
    
    func renderPieChart( result: SectionedResult<Double> ) -> UIView? {
        return nil
    }
}
