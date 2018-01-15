//
//  SetDefaultsAction.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation
import os.log

/// Used as an example for setting defaults.
let setDefaultsAction = FirstLaunchAction() { upgrade in
    os_log("SetDefaultsAction called.", log: appActionLog, type: .info)
    if let update = upgrade {
        os_log("Change %s", log: appActionLog, type: .info, "\(update)")
    }
}
