//
//  NotificationUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/8/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UserNotifications
import os.log

/**
    This is a utility class which facilitates scheduling and handling of notifications
 */
@available(iOS 10.0, *)
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
        os_log("Retrieving notification types",
               log: ui_log,
               type: .info)
        self.knownTypes = [String:LiftrackerNotification.Type]()
        
        if let notifications = ReflectionUtil.getImplementing( LiftrackerNotification.self )
            as? [ LiftrackerNotification.Type ] {
            
            for notification in notifications {
                
                let id = notification.getID()
                notification.register()
                
                os_log("Retrieved %s with id %d",
                       log: notification_log,
                       type: .debug,
                       "\(notification)", id)
                self.knownTypes[id] = notification
                
            }
        } else {
            os_log("Unable to retrieve objects implementing LiftrackerNotification",
                   log: notification_log,
                   type: .error)
        }
        os_log("Retrieved notification typed: %s",
               log: notification_log,
               type: .debug,
               "\(self.knownTypes)")
    }
    
    /**
        Registers the instance as the notification center delegate of the current notification center.
    */
    func register() {
        
        UNUserNotificationCenter.current().delegate = self
        os_log("Notification Util registered with Notification Center",
               log: notification_log,
               type: .info)
    }
    
    /**
        Schedules a notification with the current notification center with the specified parameters.  If a `LiftrackerNotification` with the specified identifier is found, and instance of that notification will be created, otherwise a local notification with the parameters will be created and displayed.
     
        - Parameters:
            - title: The notification title displayed at the top of the notification
            - body: The message content to display, provides context for the notification
            - identifier: The identifier of the type of notification to user.  If using a custom `LiftrackerNotification` use it's identifier
            - info: and additional info to provide.  This will be rendered to the notification handler when the user taps on the notification
            - delay: the amount of time to wait to present the notification
    */
    static func scheduleNotification(title: String, body: String, identifier: String, info: [AnyHashable:Any] = [:], delay: Double = 5) {
        os_log("Scheduling notification",
               log: notification_log,
               type: .info)
        os_log("title: %s, body: %s, identifier: %s, info: %s, delay: %d",
               log: notification_log,
               type: .debug,
               title, body, identifier, "\(info)", delay)
        
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
                os_log("Encountered error scheduling notification: %s",
                       log: notification_log,
                       type: .error, "\(err)")
            } else {
                os_log("Notification scheduled successfully",
                       log: notification_log,
                       type: .info)
            }
        })
    }
}

@available(iOS 10.0, *)
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
