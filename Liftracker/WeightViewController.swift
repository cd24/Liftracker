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
        else {
            let alertController = UIAlertController(title: "Enter a value!", message: "Enter a value into the weight field near the top of the screen then save it.  You do not need to put the unit (lbs/kg) as we have your preference saved.  If you do not want to use \(UserPrefs.getUnitString()) then please update your settings from the iOS settings page", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
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
    
    override func viewWillAppear(animated: Bool) {
        chart_view.animate(xAxisDuration: 1.0)
    }
    
    func buildChart() {
        setChartViewOptions()
        chart_view.data = getLineData()
    }
    
    func buildDateStrings() {
        days = ["M",
                "T",
                "W",
                "Th",
                "F",
                "S",
                "S"]
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
        chart_view.pinchZoomEnabled = true
        /*  Used for Combo chart
        chart_view.drawBarShadowEnabled = false
        
        chart_view.drawOrder = [
            CombinedChartDrawOrder.Bar.rawValue,
            CombinedChartDrawOrder.Line.rawValue
        ]
        */
        //chart_view.autoScaleMinMaxEnabled = true
        let xAxis = chart_view.xAxis
        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.BothSided
        xAxis.drawGridLinesEnabled = false
        
        chart_view.viewPortHandler.setMaximumScaleX(2.0)
        chart_view.viewPortHandler.setMaximumScaleY(2.0)
        chart_view.viewPortHandler.setMinimumScaleX(1.0)
        chart_view.viewPortHandler.setMaximumScaleY(1.0)
    }
    
    func getData() -> CombinedChartData {
        let data = CombinedChartData(xVals: days)
        data.lineData = getLineData()
        data.barData = getBarData()
        return data
    }
    
    func getLineData() -> LineChartData {
        let dataColor = UIColor.blueColor()
        var entries = [ChartDataEntry]()
        
        for i in 0..<weights.count {
            let weight_value = Double(weights[i].value!)
            let entry = ChartDataEntry(value: weight_value, xIndex: i, data: weights[i])
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(yVals: entries, label: "Weight")
        dataSet.lineWidth = 2.5
        dataSet.setColor(dataColor)
        dataSet.setCircleColor(dataColor)
        dataSet.fillColor = dataColor
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = true
        
        dataSet.drawCubicEnabled = true
        dataSet.drawValuesEnabled = true
        
        
        dataSet.valueFont = UIFont.systemFontOfSize(10.0)
        dataSet.valueTextColor = dataColor
        
        dataSet.axisDependency = ChartYAxis.AxisDependency.Left
        
        let values = Array(0..<weights.count)
        let data = LineChartData(xVals: values, dataSet: dataSet)
        
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
        var start = TimeManager.startOfWeek(NSDate()),
            end = TimeManager.endOfWeek(NSDate())
        start = TimeManager.startOfDay(start)
        end = TimeManager.endOfDay(end)
        weights = manager.getWeights(start, end: end)
        
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
    
    func dismissKeyboard() {
        if weight_field.isFirstResponder() {
            weight_field.resignFirstResponder()
        }
    }
    
    //MARK: - Chart View Delegate
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        print("Nothing selected on the chart")
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("Index \(dataSetIndex) selected.  Data = \(entry)")
    }
}
