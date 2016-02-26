//
//  WeightViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/7/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit
import Charts
import HealthKit

class WeightViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var weight_field: UITextField!
    @IBOutlet weak var weight_table_view: UITableView!
    @IBOutlet weak var chart_view: LineChartView!
    @IBOutlet weak var view_toggler: UISegmentedControl!
    
    var recognizer: UITapGestureRecognizer!
    let manager = DataManager.getInstance()
    var weights = [HKQuantitySample]()
    var first_key = "first_weight"
    
    @IBAction func save(sender: AnyObject) {
        requestWeight()
    }
    
    func requestWeight() {
        let alert = UIAlertController(title: "Add Weight", message: "Enter the weight to add.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField: UITextField!) -> Void in
            textField.placeholder = "Weight"
            textField.keyboardType = UIKeyboardType.DecimalPad
            textField.clearButtonMode = UITextFieldViewMode.Always
        })
        
        let accept = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {action in
            if let weight = Double(alert.textFields![0].text!) {
                self.weights.append(HealthKitManager.addWeight(weight))
                self.chart_view.data = self.getWeightData()
                if NSUserDefaults().boolForKey(self.first_key) {}
                else {
                    self.showConfirmDialogue()
                    UserPrefs.putAtKey(true, key: self.first_key)
                }
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(accept)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showConfirmDialogue() {
        let alert = UIAlertController(title: "Weight recieved", message: "This is the first time you have added weight.  Please note that it can take several seconds for weights to appear in the graph.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.title = "Weight"
        weight_table_view.hidden = true
        weight_table_view.dataSource = self
        weight_table_view.delegate = self
        
        recognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(recognizer)
        
        //let downImage = UIImage(named: "download.png")
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Export Image", style: UIBarButtonItemStyle.Plain, target: self, action: "saveImage")
        
        updateWeightValues()
        buildChart()
    }
    
    override func viewWillAppear(animated: Bool) {
        chart_view.animate(xAxisDuration: 1.0)
    }
    
    func buildChart() {
        setChartViewOptions()
        chart_view.data = getWeightData()
    }
    
    func setChartViewOptions() {
        chart_view.delegate = self
        chart_view.descriptionText = "Weight (\(UserPrefs.getUnitString()))"
        chart_view.noDataText = "Loading Data"
        chart_view.noDataText = ""
        chart_view.drawGridBackgroundEnabled = false
        chart_view.pinchZoomEnabled = true
        
        let xAxis = chart_view.xAxis
        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.BothSided
        xAxis.drawGridLinesEnabled = false
        
        chart_view.viewPortHandler.setMaximumScaleX(2.0)
        chart_view.viewPortHandler.setMaximumScaleY(2.0)
        chart_view.viewPortHandler.setMinimumScaleX(1.0)
        chart_view.viewPortHandler.setMaximumScaleY(1.0)
    }
    
    func getWeightData() -> LineChartData {
        let xVals = Array(0..<weights.count)
        
        let data = LineChartData(xVals: xVals, dataSets: [weightDataSet(), getBMIDataSet()])
        return data
    }
    
    func getBMIDataSet() -> LineChartDataSet {
        let color = UIColor.lightGrayColor()
        var entries = [ChartDataEntry]()
        
        for i in 0..<weights.count {
            let value = manager.bmi(weights[i].getWeightValue())
            let entry = ChartDataEntry(value: value, xIndex: i, data: weights[i])
            entries.append(entry)
        }
        
        return configureDataSet(color, entries: entries, label: "BMI")
    }
    
    func weightDataSet() -> LineChartDataSet {
        let color = UIColor.blueColor()
        var entries = [ChartDataEntry]()
        
        for i in 0..<weights.count {
            let weight_value = weights[i].getWeightValue()
            let entry = ChartDataEntry(value: weight_value, xIndex: i, data: weights[i])
            entries.append(entry)
        }
        return configureDataSet(color, entries: entries, label: "Weight")
    }
    
    func configureDataSet(color: UIColor, entries: [ChartDataEntry], label: String) -> LineChartDataSet {
        let dataSet = LineChartDataSet(yVals: entries, label: label)
        dataSet.lineWidth = 2.5
        dataSet.setColor(color)
        dataSet.setCircleColor(color)
        dataSet.fillColor = color
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = true
        
        dataSet.drawCubicEnabled = true
        dataSet.drawValuesEnabled = true
        
        
        dataSet.valueFont = UIFont.systemFontOfSize(10.0)
        dataSet.valueTextColor = color
        
        dataSet.axisDependency = ChartYAxis.AxisDependency.Left
        return dataSet
    }
    
    func updateWeightValues() {
        var start = TimeManager.startOfDay(NSDate()),
            end = TimeManager.timeTravel(steps: 30, base: start, component: NSCalendarUnit.Day)
        
        if HealthKitManager.hasPermission() {
            getFromHealthKit(start, end: end)
        }
        else {
            manager.getWeights(start, end: end)
        }
    }
    
    func getFromHealthKit(start: NSDate, end: NSDate, numEntries: Int = 50) {
        weights = [HKQuantitySample]()
        let predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", start, end)

        let weight = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let weight_query = HKSampleQuery(sampleType: weight!,
            predicate: predicate,
            limit: numEntries,
            sortDescriptors: nil,
            resultsHandler: {(query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    self.weights = results
                    self.chart_view.data = self.getWeightData()
                    self.chart_view.notifyDataSetChanged()
                    self.weight_table_view.reloadData()
                    self.chart_view.noDataText = "No Data!  Add some at your leisure"
                }
                else {
                    print("There was a problem accessing health kits weight data \n\(error)")
                }
        })
        HealthKitManager.executeQuery(weight_query)
    }
    
    func getFromHealthKit(numEntries: Int = 50) {
        weights = [HKQuantitySample]()
        
        let weight = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)

        let weight_query = HKSampleQuery(sampleType: weight!,
            predicate: nil,
            limit: numEntries,
            sortDescriptors: nil,
            resultsHandler: {(query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    self.weights = results
                    self.chart_view.data = self.getWeightData()
                    self.chart_view.notifyDataSetChanged()
                    self.weight_table_view.reloadData()
                    self.chart_view.noDataText = "No Data!  Add some at your leisure"
                }
                else {
                    print("There was a problem accessing health kits weight data \n\(error)")
                }
        })
        HealthKitManager.executeQuery(weight_query)
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
    
    @IBAction func segmentToggle(sender: UISegmentedControl) {
        if view_toggler.selectedSegmentIndex == 0 {
            //hide table show chart
            weight_table_view.hidden = true
            weight_table_view.userInteractionEnabled = false
            chart_view.hidden = false
            chart_view.userInteractionEnabled = true
            //chart_view.animate(xAxisDuration: 1.0)
        }
        else if view_toggler.selectedSegmentIndex == 1 {
            //show table hide chart
            weight_table_view.hidden = false
            weight_table_view.userInteractionEnabled = true
            chart_view.hidden = true
            chart_view.userInteractionEnabled = false
        }
    }
    //MARK: - Chart View Delegate
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        print("Nothing selected on the chart")
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("Index \(dataSetIndex) selected.  Data = \(entry)")
    }
    
    //MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        weight_table_view.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MAKR: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weights.count + 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = weight_table_view.dequeueReusableCellWithIdentifier("Cell") as! LeftRightTableViewCell
        if indexPath.row == 0 {
            //header
            cell.leftText.text = "Date"
            cell.rightText.text = "Weight"
        }
        else {
            let data = weights[indexPath.row - 1]
            cell.leftText.text = TimeManager.dateToString(data.startDate)
            cell.rightText.text = "\(data.getWeightValue()) \(UserPrefs.getUnitString())"
        }
        return cell
    }

}
