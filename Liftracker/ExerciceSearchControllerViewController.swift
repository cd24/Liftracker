//
//  ExerciceSearchControllerViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/6/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit

class ExerciceSearchControllerViewController: UISearchController {

    var data: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateData(data: [String]) {
        self.data = data
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
