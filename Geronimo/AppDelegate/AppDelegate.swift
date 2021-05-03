//
//  AppDelegate.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import CoreData
import UIKit
import UserNotifications

@UIApplicationMain
final class AppDelegate: UIResponder {

    var window: UIWindow?

}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let rootVC = TimersVC()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.isNavigationBarHidden = true
        navVC.navigationBar.isTranslucent = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        // Register notification delegate + request permission
        UNUserNotificationCenter.current().delegate = NotificationsManager.sharedInstance
        NotificationsManager.sharedInstance.requestUserPermission()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationsManager.sharedInstance.updateLocalDBNotificationID), object: nil)
    }
    
}
