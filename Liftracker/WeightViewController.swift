//
//  WeightViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/7/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit
import Charts

class WeightViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var weight_field: UITextField!
    //@IBOutlet weak var notes_field: UITextView!
    @IBOutlet weak var chart_view: LineChartView!
    @IBOutlet weak var view_toggler: UISegmentedControl!
    
    var recognizer: UITapGestureRecognizer!
    let manager = DataManager.getInstance()
    var weights = [Weight]()
    
    var days = [NSObject]()
    var months = [NSObject]()
    
    @IBAction func save(sender: AnyObject) {
        if let weight = Int(weight_field.text!) {
            manager.addWeight(weight, notes: "", date: NSDate())
            updateWeightValues()
        }
    }
    
    override func viewDidLoad() {
        self.title = "Weight"
        
        recognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(recognizer)
        
        updateWeightValues()
        buildDateStrings()
        buildChart()
    }
    
    func buildChart() {
        setChartViewOptions()
        chart_view.data = getLineData()
    }
    
    func buildDateStrings() {
        days = ["M", "T", "W", "Th", "F", "S", "S"]
        months = ["Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec"]
    }
    
    func setChartViewOptions() {
        chart_view.delegate = self
        chart_view.descriptionText = "Weight (\(UserPrefs.getUnitString()))"
        chart_view.noDataTextDescription = "There is no weight data yet!  Add some!"
        chart_view.noDataText = ""
        chart_view.drawGridBackgroundEnabled = false
        /*  Used for Combo chart
        chart_view.drawBarShadowEnabled = false
        
        chart_view.drawOrder = [
            CombinedChartDrawOrder.Bar.rawValue,
            CombinedChartDrawOrder.Line.rawValue
        ]
        */
        chart_view.autoScaleMinMaxEnabled = true
        let rightAxis = chart_view.rightAxis
        let leftAxis = chart_view.leftAxis
        let xAxis = chart_view.xAxis
        rightAxis.drawGridLinesEnabled = false
        leftAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.BothSided
    }
    
    func getData() -> CombinedChartData {
        let data = CombinedChartData(xVals: days)
        data.lineData = getLineData()
        data.barData = getBarData()
        return data
    }
    
    func getLineData() -> LineChartData {
        let data = LineChartData()
        let dataColor = UIColor.greenColor()
        var entries = [ChartDataEntry]()
        
        for i in 0..<weights.count {
            let weight_value = Double(weights[i].value!)
            let entry = ChartDataEntry(value: weight_value, xIndex: i, data: weights[i])
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(yVals: entries, label: "Weights")
        dataSet.lineWidth = 2.5
        dataSet.setColor(dataColor)
        dataSet.setCircleColor(dataColor)
        dataSet.fillColor = dataColor
        
        dataSet.drawCubicEnabled = true
        dataSet.drawValuesEnabled = true
        
        dataSet.valueFont = UIFont.systemFontOfSize(10.0)
        dataSet.valueTextColor = dataColor
        
        dataSet.axisDependency = ChartYAxis.AxisDependency.Left
        
        data.addDataSet(dataSet)
        
        return data
    }
    
    func getBarData() -> BarChartData {
        let data = BarChartData()
        let dataColor = UIColor.blueColor()
        var entries = [BarChartDataEntry]()
        
        let today = NSDate()
        for i in 0..<7 {
            let current_date = TimeManager.timeTravel(steps: i, base: today)
            let weight_average = averageForDay(current_date)
            let BMI = manager.bmi(weight_average)
            print(BMI)
            let entry = BarChartDataEntry(value: BMI, xIndex: i, data: current_date)
            entries.append(entry)
        }
        
        let dataSet = BarChartDataSet(yVals: entries, label: "BMI")
        
        dataSet.setColor(dataColor)
        dataSet.valueTextColor = dataColor
        dataSet.valueFont = UIFont.systemFontOfSize(10.0)
        
        dataSet.axisDependency = ChartYAxis.AxisDependency.Left
        
        data.addDataSet(dataSet)
        
        return data
    }
    
    func updateWeightValues() {
        let start_of_week = TimeManager.startOfWeek(NSDate()),
            end_of_week = TimeManager.endOfWeek(NSDate())
        weights = manager.getWeights(start_of_week, end: end_of_week)
        buildChart()
    }
    
    func saveImage() {
        chart_view.saveToCameraRoll()
    }
    
    func averageForDay(day: NSDate) -> Double {
        var sum = 0.0
        let data = manager.getWeights(date: day)
        data.forEach { w in
            return sum += Double(w.value!)
        }
        return sum/Double(data.count)
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        print("Nothing selected on the chart")
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("Index \(dataSetIndex) selected.  Data = \(entry)")
    }
    
    func dismissKeyboard() {
        if weight_field.isFirstResponder() {
            weight_field.resignFirstResponder()
        }
    }
}
