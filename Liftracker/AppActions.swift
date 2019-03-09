//
//  AppActions.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation
import UIKit

/// Basically a global array for AppActions.
public class AppActions: BaseUtil {
    public static let shared = AppActions()
    private var actions: [AppAction]
    private let dispatch: DispatchQueue
    
    override private init() {
        actions = []
        dispatch = DispatchQueue(label: "AppActions",
                                 qos: .utility)
    }
    
    public func add(action: AppAction) {
        actions.append(action)
    }
    
    public func trigger(_ event: EventType) {
        actions.forEach { exec($0, event) }
    }
    
    private func exec(_ action: AppAction, _ event: EventType) {
        // Determine which dispatch queue to use for executing
        let queue = action.configuration.syncronous ? DispatchQueue.main : dispatch
        queue.sync {
            action.run(for: event)
        }
    }
}
