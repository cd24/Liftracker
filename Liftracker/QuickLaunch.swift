//
//  QuickLaunch.swift
//  Liftracker
//
//  Created by John McAvey on 2/14/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit

enum QuickLaunchType: String{
    case OpenStats
    case OpenHistory
    case AddExercice
    
    init?(fullIdentified: String) {
        guard let id = fullIdentified.componentsSeparatedByString(".").last else {
            return nil
        }
        self.init(rawValue: id)
    }
}