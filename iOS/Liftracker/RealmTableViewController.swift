//
//  RealmTableViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit

/**
 Generic implementation for showing realm tables to users. Most table view settings are left as default and can be manipulated in the specific implementation. 
 Provides standard implementations for adding and editing data on the front end.
 
 Currently only supports one section
 */
class RealmTableViewController: UITableViewController {
    
    var results: RLMResults<RLMObject>? = nil
    var realm: RLMRealm = RLMRealm.default()
    
    var canAdd: Bool = false
    var canEdit: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        self.reload()
        
        if canAdd {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addRequested))
        }
        if canEdit {
            showEditButtonIfNeeded()
        }
    }
    
    func showEditButtonIfNeeded() {
        
        if (results?.count ?? 0) > 0 {
            self.navigationItem.rightBarButtonItem = self.editButtonItem
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    /**
     Refreshs the results and reloads the table view
    */
    func reload() {
        
        self.results = self.getObjects()
        self.tableView.reloadData()
        
    }
    
    func delete(index: Int) {
        log.debug( "Deleting item at index: \(index)" )
        if index < (Int(results?.count ?? 0)) && index >= 0 {
            
            log.debug("willDelete called for index: \(index)")
            self.willDelete( index: index )
            
            realm.write(block: { realm in
                
                if let object = results?.object(at: UInt(index)) {
                    log.verbose("Object deleted from realm")
                    realm.delete(object)
                }
                
                }, complete: {
                    DispatchQueue.main.async {
                        self.results = self.getObjects()
                        log.debug("didDelete called for index: \(index)")
                        self.didDelete( index: index )
                    }
            })
        } else {
            log.warning("Attempted to delete an object at an index out of range: index \(index), size: \(results?.count)")
        }
    }
    
    // MARK: - Extensibility Methods
    
    /**
     Used for applying any filtereing of the data.  Override to customize what data is displayed, defaults to all.
    */
    func predicate() -> NSPredicate {
        return NSPredicate()
    }
    
    /**
     Called before an object is deleted from the Realm.  
     - Warning: All objects are considered deletable.  If you need to make some objects unavailable to delete, override the tableview method.  Realm objects are accessible through the variable `results`.
    */
    func willDelete( index: Int ) {
        
    }
    
    /**
     Called imidiately after an object was deleted from the realm.  Perform any animations/cleanup required here.  Default implementation adds slide out animation
    */
    func didDelete( index: Int ) {
        // TODO: add slide out animation
        
    }
    
    /**
     Invoked when the user taps the "+" button is pressed.  The button is only shown if the `canAdd` property returns true
     Must handle requesting the information from the user and saving/animating the add.
    */
    func addRequested() {
        
    }
    
    func getObjects() -> RLMResults<RLMObject>? {
        return nil
    }
    
    // MARK :- Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(results?.count ?? 0)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK :- Delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delete(index: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
