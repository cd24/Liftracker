//
//  WorkoutNotification.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UserNotifications

@available(iOS 10.0, *)
class WorkoutNotification : LiftrackerNotification {
    
    required init(incoming: UNNotificationResponse) {
        
    }
    
    static func getID() -> String {
        return "WorkoutNotification"
    }
    
    static func register() {
        
    }
    
    func complete() {
        
    }
    
    func handle() {
        
    }
}
