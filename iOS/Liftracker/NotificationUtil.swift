//
//  NotificationUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/8/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UserNotifications


/**
    This is a utility class which facilitates scheduling and handling of notifications
 */
class NotificationUtil: NSObject {
    
    /**
        This shared instance should be used when registering with the notification center and when schedule and handling notifications.
    */
    static let shared = NotificationUtil()
    
    /**
        Registers the instance as the notification center delegate of the current notification center.
    */
    func register() {
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    /**
        Schedules a notification with the current notification center with the specified parameters.  If a notification type with the specified identifier is found, and instance of that notification will be created, otherwise a local notification with the parameters will be created and displayed.
    */
    func scheduleNotification(title: String, body: String, identifier: String, delay: Double = 5) {
        
        
    }
}

extension NotificationUtil : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // todo
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // todo
    }
}

/**
    This protocol describes a type of notification which can be sent from the Liftracker app.  Any implementation of this protocol will be added to the notification utility when the utility is created in application(:didFinishLaunching:withOptions)
 */
protocol LiftrackerNotification {
    
    /**
        This ID will be used to associate incoming system notifications with the current notification.  This should be a unique identifier not based on the content it contains.
    */
    func getID() -> String
    
    /**
        this method will be invoked when the identifier of an incoming notification matches the identifier from this object.  This method should respond appropriately to the incoming notification, with the assumption that the identifiers match.
    */
    func handle(incoming: UNNotification)
    
    /** 
        called in place of init - this method is called when a notification of this type is scheduled.
    */
    func create(title: String, body: String) -> LiftrackerNotification
}
