//
//  LocalNotificationContracts.swift
//  ToDoApp
//
//  Created by ulas on 22.10.2021.
//

import Foundation
import UserNotifications

protocol LocalNotificationManagerProtocol {
    func authorizeNotification()
    func configureNotification()
    func scheduledNotificationRequest(with deadline: Date, with todoTitle: String)
    func getNotificationAttachment() -> UNNotificationAttachment?
}
