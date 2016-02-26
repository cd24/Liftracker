//
//  ChartViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/4/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chart_view: UIView!
    var chart_type: ChartType!
    var exercice: Exercice!
    var month: NSDate!
    var center_text: String!
    var pieData: (() -> PieChartData)!
    var data_changed = true
    
    @IBOutlet weak var pie_view: PieChartView!
    var bubble_view: BubbleChartView!
    let manager = DataManager.getInstance()
    
    
    @IBAction func done(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildPieChart()
    }
    
    override func viewDidAppear(animated: Bool) {
        if data_changed {
            pie_view.data = pieData()
            data_changed = false
        }
        pie_view.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
        pie_view.noDataText = "No data added!\nRecord some data to get your information!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildPieChart() -> PieChartView {
        if let bv = bubble_view {
            bv.removeFromSuperview()
            bubble_view = nil
        }
        let pcv = pie_view
        pcv.delegate = self
        pcv.usePercentValuesEnabled = true
        pcv.holeRadiusPercent = 0.58
        pcv.transparentCircleRadiusPercent = 0.62
        pcv.descriptionText = "" //NO DESCRIPTIONS!
        pcv.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        pcv.drawCenterTextEnabled = true
        pcv.centerText = getCenterText().string
        
        pcv.drawHoleEnabled = true
        pcv.rotationAngle = 0.0
        pcv.rotationEnabled = true
        pcv.noDataText = "Loading Data..."
        pcv.drawSliceTextEnabled = false
        
        let l = pcv.legend
        l.position = ChartLegend.ChartLegendPosition.RightOfChart;
        l.xEntrySpace = 7.0;
        l.yEntrySpace = 0.0;
        l.yOffset = 0.0;
        
        return pcv
    }
    
    func getCenterText() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: center_text)
    }
    
    func updateData() {
        data_changed = true
    }
    
    //MARK: - ChartViewDelegate 
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        print("Nothing selected on the chart")
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("Index \(dataSetIndex) selected.  Data = \(entry)")
        chartView.highlightValues(nil);
    }
    
    enum ChartType {
        case WorkDistribution
        case Execrice
        case MonthDistribution
    }

}
