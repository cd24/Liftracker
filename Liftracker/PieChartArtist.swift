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
import os.log

/**
    Renders Sectioned data into a pie chart.  Requires SectionResult<Double>
 */
class PieChartArtist : Artist {
    
    required init() {
        os_log("Initialized a PieCharArtist",
               log: ui_log,
               type: .info)
    }
    
    /**
        Renders the results as a pie chart
    
        - Parameters:
            - result: MUST be a SectionedResult<Double>, otherwise, an error is shown.
    */
    func render(result: AnalystResult) -> Promise<UIView> {
        return Promise<UIView> {
            os_log("Rendering pie chart view",
                   log: ui_log,
                   type: .info)
            os_log("Rendering from %s",
                   log: ui_log,
                   type: .debug,
                   "\(result)")
            
            if let pieResult = result as? SectionedResult<Double> {
                // TODO: render a pie chart and display the data.
                os_log("Processing pie chart data %s",
                       log: ui_log,
                       type: .debug,
                       "\(pieResult)")
                if let view = renderPieChart(result: pieResult) {
                    $0.fulfill( view )
                } else {
                    os_log("Unable to render pie view with data: %s",
                           log: ui_log,
                           type: .info)
                    $0.reject( ArtistError.generic )
                }
            } else {
                $0.reject( ArtistError.unkownData )
            }
        }
    }
    
    func renderPieChart( result: SectionedResult<Double> ) -> UIView? {
        return nil
    }
}
