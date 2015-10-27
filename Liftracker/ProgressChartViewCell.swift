//
//  ProgressChartViewCell.swift
//  Liftracker
//
//  Created by John McAvey on 10/26/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit
import Charts

class ProgressChartViewCell: UICollectionViewCell {
    @IBOutlet var header: UILabel!
    @IBOutlet var chartArea: UIView!
    let manager = DataManager.getInstance()
    var loadedEx: Exercice!, exercice: Exercice!
    var reps: [Rep]!
    var chart: LineChartView!
    //todo: Draw chart from given data
    
    func setup(){
        chart = LineChartView(frame: chartArea.frame)
        chart.autoScaleMinMaxEnabled = true
        chartArea.addSubview(chart)
    }
    
    func updateChart(){
        if loadedEx != nil || loadedEx != exercice{
            //redraw
            var dataArray: [Int] = []
            let reps = manager.loadAllRepsFor(exercice: exercice)
            for rep in reps{
                dataArray.append(rep.weight!.integerValue)
            }
            let data = LineChartData(xVals: dataArray)
            chart.data = data
            
            loadedEx = exercice
        }
    }
}
