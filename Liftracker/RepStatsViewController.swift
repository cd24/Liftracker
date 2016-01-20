//
//  RepStatsViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/17/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit
import Charts

class RepStatsViewController: UIViewController {

    lazy var manager = DataManager.getInstance()
    var exercice: Exercice!
    
    @IBOutlet weak var chart_view: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func done(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //todo:In order to build this I will need to migrate reps from string dates to NSDates
    /*
    func weightDataSet() -> LineChartDataSet {
        let color = UIColor.blueColor()
        var entries = [ChartDataEntry]()
        
        for i in 0..<weights.count {
            let weight_value = weights[i].getWeightValue()
            let entry = ChartDataEntry(value: weight_value, xIndex: i, data: weights[i])
            entries.append(entry)
        }
        return configureDataSet(color, entries: entries, label: "Weight")
    }*/
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
