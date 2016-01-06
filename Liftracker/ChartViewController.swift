//
//  ChartViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/4/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    enum ChartType {
        case WorkDistribution
        case Execrice
        case MonthDistribution
    }

}
