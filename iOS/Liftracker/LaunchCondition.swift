//
//  LaunchCondition.swift
//  Liftracker
//
//  Created by John McAvey on 12/4/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

@objc protocol LaunchCondition {
    
    func satisfied() -> Bool
}
