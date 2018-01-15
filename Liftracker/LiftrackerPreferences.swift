//
//  LiftrackerPreferences.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

let preferencePrefix = "com.liftracker"

func liftrackerPrefrence<T>(_ name: String) -> KVEntry<T> {
    return defaultsEntry("\(preferencePrefix).\(name)")
}

/// keep in cm, translate to feet/in if needed.
let height: KVEntry<Double> = liftrackerPrefrence("height")
let age: KVEntry<Int> = liftrackerPrefrence("age")
let sex: KVEntry<String> = liftrackerPrefrence("sex")
