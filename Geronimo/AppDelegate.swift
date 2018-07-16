//
//  AppDelegate.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationsManager.sharedInstance.updateLocalDBNotificationID), object: nil)
    }

}

