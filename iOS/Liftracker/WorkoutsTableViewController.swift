//
//  WorkoutsTableViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit

class WorkoutsTableViewController: RealmTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canAdd = false
        self.canEdit = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = (results?.object(at: UInt(indexPath.row)) as? Workout)?.name
        
        return cell
    }
    
    override func getObjects() -> RLMResults<RLMObject>? {
        return Workout.allObjects()
    }
}
