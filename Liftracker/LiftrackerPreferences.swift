//
//  LiftrackerPreferences.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

let preferencePrefix = "com.liftracker.os"

/// keep in cm, translate to feet/in if needed.
let height = Preference("\(preferencePrefix).height")
let age = Preference("\(preferencePrefix).age")
let sex = Preference("\(preferencePrefix).sex")
