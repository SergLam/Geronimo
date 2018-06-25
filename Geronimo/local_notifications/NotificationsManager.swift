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
    
    func sendNotification(timerTitle: String, timerDescription: String, timerNotificationID: String) {
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
            //it will be called after 2 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            
            //getting the notification request
            let request = UNNotificationRequest(identifier: timerNotificationID, content: content, trigger: trigger)
            
            //adding the notification to notification center
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    // MARK: UNUserNotificationCenterDelegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case NotificationActionsID.later.rawValue:
            print("Later button pressed")
        case NotificationActionsID.confirm.rawValue:
            print("Timer confirmed")
            let notification_ID = response.notification.request.identifier // equal to timerID
            // TODO: update active timer success count + delete ended timer
            confirmTimer(timerNotificationID: notification_ID)
            UIApplication.shared.applicationIconBadgeNumber = 0
        default:
            print("Other Action")
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
        //required to show notification when in foreground
    }
    
    func removeNotification(timerLastNotificationID: String){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == timerLastNotificationID {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    // MARK: generate random string for usage like notification ID
    func randomString(length: Int = 15) -> String{
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func confirmTimer(timerNotificationID: String){
        // TODO: write method for DB to get active timer by lastnotificationID field
        if let active_timer = DBManager.sharedInstance.getTimerByNotificationID(id: timerNotificationID){
           active_timer.succesCount = active_timer.succesCount + 1
            DBManager.sharedInstance.addTimer(object: active_timer)
            if let ended_timer = DBManager.sharedInstance.getEndedTimerByID(timerID: active_timer.id){
                DBManager.sharedInstance.deleteEndedTimer(object: ended_timer)
            }
        }
    }
    
}
