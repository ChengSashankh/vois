//
//  AppDelegate.swift
//  Vois
//
//  Created by Jiang Yuxin on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let notificationsCenter = NotificationCenter.default
    let notificationsController = NotificationsDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.setUpNotifications()

        return true
    }

    private func setUpNotifications() {
        self.notificationsController.notificationCenter.delegate = notificationsController
        self.notificationsController.requestPermissions()
        self.notificationsController.removeNotification(identifier: "App Unused for 1 Week")

        notificationsCenter.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                        object: nil,
                                        queue: nil) { _ in
            // Notification repeats every 3 days to remind user to practice regularly.
            self.notificationsController.scheduleNotification(title: "We missed you!",
                                                              body:
                "It's been a while since you've last practiced.\nLet's start now! :)",
                                                              identifier: "App Unused for 1 Week",
                                                              timeInterval: 3 * 24 * 60 * 60)
        }

        notificationsCenter.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                        object: nil,
                                        queue: nil) { _ in
            self.notificationsController.removeNotification(identifier: "App Unused for 1 Week")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this
        // will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded
        // scenes, as they will not return.
    }

}
