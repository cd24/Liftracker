//
//  HomeCardCollectionViewCell.swift
//  Liftracker
//
//  Created by John McAvey on 10/18/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class HomeCardCollectionViewCell: UICollectionViewCell {
    var tableView: HomeCellTableViewController?
    
    func setData(data: [Rep]){
        tableView?.reps = data
        tableView?.tableView.reloadData()
    }
    
    func addRep(rep: Rep){
        tableView?.reps.append(rep)
        tableView?.tableView.reloadData()
    }
}
