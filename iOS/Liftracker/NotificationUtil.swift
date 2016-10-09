//
//  NotificationUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/8/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UserNotifications
import Crashlytics

/**
    This is a utility class which facilitates scheduling and handling of notifications
 */
class NotificationUtil: BaseUtil {
    
    /**
        This shared instance should be used when registering with the notification center and when schedule and handling notifications.
    */
    static let shared = NotificationUtil()
    
    var knownTypes: [String:LiftrackerNotification.Type]
    
    override init() {
        self.knownTypes = [String:LiftrackerNotification.Type]()
        super.init()
        
        populateTypes()
    }
    
    /**
        Prepares the object for use by loading in all objects implementing LiftrackerNotification into a map for use.
    */
    func populateTypes() {
        
        log.verbose("Retrieving notification types")
        self.knownTypes = [String:LiftrackerNotification.Type]()
        
        if let notifications = ReflectionUtil.getImplementing( LiftrackerNotification.self )
            as? [ LiftrackerNotification.Type ] {
            
            for notification in notifications {
                
                let id = notification.getID()
                notification.register()
                
                log.verbose("Retrieved \(notification) with id \(id)")
                
                self.knownTypes[id] = notification
                
            }
        } else {
            log.error("Unable to retrieve objects implementing \(LiftrackerNotification.self)")
        }
        
        log.verbose("Retrieved \(self.knownTypes)")
    }
    
    /**
        Registers the instance as the notification center delegate of the current notification center.
    */
    func register() {
        
        UNUserNotificationCenter.current().delegate = self
        log.info("Notification Util registered with Notification Center")
    }
    
    /**
        Schedules a notification with the current notification center with the specified parameters.  If a `LiftrackerNotification` with the specified identifier is found, and instance of that notification will be created, otherwise a local notification with the parameters will be created and displayed.
    */
    static func scheduleNotification(title: String, body: String, identifier: String, info: [AnyHashable:Any] = [:], delay: Double = 5) {
        
        
        log.verbose("Scheduling notification with title: \(title), body: \(body), identifier: \(identifier), info: \(info), delay: \(delay)")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = info
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let err = error {
                log.info("Encountered error scheduling notification: \(err)")
            } else {
                log.info("Notification scheduled successfully.")
            }
        })
    }
}

extension NotificationUtil : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler( .alert )
    }
    
    // attempts to associate the response with an `LiftrackerNotification` and handle the response.  Otherwise, ignores it.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let handler = knownTypes[ response.notification.request.identifier ] {
            
            let instance = handler.init(incoming: response)
            
            instance.handle()
            
            instance.complete()
        }
        
        completionHandler()
    }
}
