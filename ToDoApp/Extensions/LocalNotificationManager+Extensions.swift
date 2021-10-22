//
//  LocalNotificationManager+Extensions.swift
//  ToDoApp
//
//  Created by ulas on 16.10.2021.
//

import Foundation
import UserNotifications

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification did receive response")

        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification will present")

        let options: UNNotificationPresentationOptions = [.badge, .sound]
        completionHandler(options)
    }
}
