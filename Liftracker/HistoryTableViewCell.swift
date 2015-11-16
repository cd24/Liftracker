//
//  HistoryTableViewCell.swift
//  Liftracker
//
//  Created by John McAvey on 11/7/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet var weight: UILabel!
    @IBOutlet var rep: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
