//
//  ChartViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/4/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chart_view: UIView!
    var chart_type: ChartType!
    var exercice: Exercice!
    var month: NSDate!
    
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
        pie_view.data = pieData()
        pie_view.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
        pie_view.noDataText = "No data added!\nRecord some data to get your information!"
    }
    
    func pieData() -> PieChartData {
        var reps = [BarChartDataEntry]()
        var xVals = [String]()
        var mgs = manager.loadAllMuscleGroups()
        for i in 0..<mgs.count {
            let mg = mgs[i]
            let predicate = NSPredicate(format: "exercice.muscle_group.name == '\(mg.name!)'")
            let count = manager.entityCount(entityType: "Rep", predicate: predicate)
            if count > 0 {
                reps.append(BarChartDataEntry(value: Double(count), xIndex: i))
                xVals.append(mg.name!)
            }
        }
        
        let dataSet = PieChartDataSet(yVals: reps, label: "Muscle Group Breakdown")
        dataSet.sliceSpace = 2.0
        dataSet.colors = pieColors()
        
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        data.setValueFormatter(pieNumberFormatter())
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor.blackColor())
        
        return data
    }
    
    func pieColors() -> [UIColor] {
        var colors = [UIColor]()
        colors.appendContentsOf(ChartColorTemplates.vordiplom())
        colors.appendContentsOf(ChartColorTemplates.joyful())
        colors.appendContentsOf(ChartColorTemplates.colorful())
        colors.appendContentsOf(ChartColorTemplates.liberty())
        colors.appendContentsOf(ChartColorTemplates.pastel())
        return colors
    }
    
    func pieNumberFormatter() -> NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        return formatter
    }
    
    func bubbleData() -> BubbleChartData{
        let data = BubbleChartData()
        return data
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
        
        let l = pcv.legend
        l.position = ChartLegend.ChartLegendPosition.RightOfChart;
        l.xEntrySpace = 7.0;
        l.yEntrySpace = 0.0;
        l.yOffset = 0.0;
        
        //chart_view.addSubview(pcv)
        return pcv
    }
    /*
    func buildBubbleChart() -> BubbleChartView {
        if let pv = pie_view {
            pv.removeFromSuperview()
            pie_view = nil
        }
        let bcv = BubbleChartView(frame: chart_view.frame)
        //todo: Configure BCV
        return bcv
    }
    */
    
    func getCenterText() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "Exercice Distribution\nby Muscle Group")
    }
    
    enum ChartType {
        case WorkDistribution
        case Execrice
        case MonthDistribution
    }

}
