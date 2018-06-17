//
//  NotificationsManager.swift
//  Geronimo
//
//  Created by Serg Liamthev on 6/17/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsManager: NSObject, UNUserNotificationCenterDelegate{
    
    static let sharedInstance = NotificationsManager()
    
    var permissionResult: Bool = false
    
    func requestUserPermission(){
        configureNotificationCenter()
        // MARK: Request permission for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if(granted == true){
                self.permissionResult = true
            } else{
                let alert = UIAlertController(title: "Notification Access", message: "In order to use this application, turn on notification permission in Settings app.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(alertAction)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func configureNotificationCenter(){
         UNUserNotificationCenter.current().delegate = self
        // Define Actions
        let actionLater = UNNotificationAction(identifier: NotificationActionsID.later.rawValue, title: NotificationActionsTitles.later.rawValue, options: [])
        let actionConfirm = UNNotificationAction(identifier: NotificationActionsID.confirm.rawValue, title: NotificationActionsTitles.confirm.rawValue, options: [.foreground])
        // Define Category
        let tutorialCategory = UNNotificationCategory(identifier: NotificationCategory.name.rawValue, actions: [actionLater, actionConfirm], intentIdentifiers: [], options: [])
        // Register Category
        UNUserNotificationCenter.current().setNotificationCategories([tutorialCategory])
    }
    
    func sendNotification(timerTitle: String, timerDescription: String) {
        if(permissionResult){
            //creating the notification content
            let content = UNMutableNotificationContent()
            
            //adding title, subtitle, body and badge
            content.title = timerTitle
            content.body = timerDescription
            content.badge = 1
            content.sound = UNNotificationSound.default()
            // Set Category Identifier
            content.categoryIdentifier = NotificationCategory.name.rawValue
            //getting the notification trigger
            //it will be called after 5 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //getting the notification request
            let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
            
            //adding the notification to notification center
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    // MARK: UNUserNotificationCenterDelegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case NotificationActionsID.later.rawValue:
            print("Save Tutorial For Later")
        case NotificationActionsID.confirm.rawValue:
            print("Timer confirmed")
            UIApplication.shared.applicationIconBadgeNumber = 0
        default:
            print("Other Action")
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge]) //required to show notification when in foreground
    }
    
}
