//
//  SetDefaultsAction.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation


/// Used as an example for setting defaults.
class SetDefaultsAction: FirstLaunchAction {
    override func execute(_ upgrade: Bool) {
        log.verbose("Setting defaults")
        log.verbose("Is upgrade: \(upgrade)")
    }
}
