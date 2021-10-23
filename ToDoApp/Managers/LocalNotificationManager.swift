//
//  NotificationService.swift
//  ToDoApp
//
//  Created by ulas on 14.10.2021.
//

import Foundation
import UserNotifications

class LocalNotificationManager: NSObject {

    let center = UNUserNotificationCenter.current()

    // MARK: - Notification Content

    func authorizeNotification() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { granted, error in

            print(error?.localizedDescription ?? "Notification authorization successful")

            guard granted else {
                print("User denied notification permission")
                return
            }
            self.configureNotification()
        }

    }

    func configureNotification() {
        center.delegate = self
    }

    // MARK: - Notification Trigger

    func scheduledNotificationRequest(with deadline: Date, with todoTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Your time is up!"
        content.body = "Complete your \(todoTitle) task. Lazy!"
        content.sound = .default
        // Notification badge always show 1 notification on app icon
        content.badge = 1

        if let attachment = getNotificationAttachment() {
            content.attachments = [attachment]
        }

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: deadline)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: K.Notification.identifier, content: content, trigger: trigger)

        center.add(request)
    }

    // MARK: - Notification Attachment

    func getNotificationAttachment() -> UNNotificationAttachment? {
        guard let url = Bundle.main.url(forResource: K.Notification.imageName, withExtension: "png") else { return nil }

        do {
            let attachment = try UNNotificationAttachment(identifier: K.Notification.identifier, url: url)
            return attachment
        } catch {
            return nil
        }
    }

}
