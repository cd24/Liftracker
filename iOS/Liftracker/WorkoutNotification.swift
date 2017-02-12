//
//  WorkoutNotification.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UserNotifications

/**
 These noitications will target workout reminders.  If the app finds a workout scheduled when it enters the background, it will this notification for presentation 1 hour before the workout should start.  Selecting this notification will take the user to that workout.
 */

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
