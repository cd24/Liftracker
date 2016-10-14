//
//  ExerciceTableViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit

class ExerciceTableViewController: RealmTableViewController {
    
    var workout: Workout?
    var type: Type?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canAdd = false
        self.canEdit = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = (results?.object(at: UInt(indexPath.row)) as? Exercice)?.name
        
        return cell
    }
    
    override func getObjects() -> RLMResults<RLMObject>? {
        
        let predicate: NSPredicate?
        if let wk = workout {
            predicate = NSPredicate(format: "workout == %@", wk)
            
        } else if let tp = type {
            
            predicate = NSPredicate(format: "type == %@", tp)
        } else {
            predicate = nil
        }
        
        return Exercice.objects(with: predicate)
    }
}
