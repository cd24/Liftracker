//
//  LiftrackerPreferences.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

let preferencePrefix = "com.liftracker.os"
let globalPrefix = "global"

/**
 This function acts as a helper to generating preferences with the proper form. Abstracts some of the redundancy of using a common prefix for preferences.
 Preference postfixes should be scoped. For example, a preference for module `M` should be named `"M.Preference"` to prevent naming coliisions.
 Global preferences should be demarked as such with the "global" module
 If possible, create a helper function to keep naming consistent.
 - parameter element: The postfix component of the preference, should be scoped.
 - returns: the preference with the base Liftracker prefix prepended.
 */
func lPreference<T>(_ element: String) -> Preference<T> {
    return Preference("\(preferencePrefix).\(element)")
}

/**
 Helper function to create globally scoped preferences.
 - parameter named: The name to postpend to the global prefix
 - returns: the preference with the form { Base liftracker id }.{ global id }.{ provided name }
 */
func globalPreference<T>(_ named: String) -> Preference<T> {
    return lPreference("\(globalPrefix).\(named)")
}

let userHeight: Preference<Double> = globalPreference("height")
let userAge: Preference<Int> = globalPreference("age")
let userSex: Preference<String> = globalPreference("sex") // Might want to try to turn this into an Enum eventually for more checking

