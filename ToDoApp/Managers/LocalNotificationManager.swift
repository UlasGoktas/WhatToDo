//
//  NotificationService.swift
//  ToDoApp
//
//  Created by ulas on 14.10.2021.
//

import Foundation
import UserNotifications
import UIKit

class NotificationService: NSObject {
    
    private override init() {}
    static let shared = NotificationService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    //MARK: - Notification Content
    
    func authorize() -> Void {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { granted, error in
            
            print(error?.localizedDescription ?? "Authorization error")
            
            guard granted else {
                print("User denied notification permission")
                return
            }
            self.configure()
        }
        
    }
    
    func configure() -> Void {
        unCenter.delegate = self
        
    }
    
    //MARK: - Notification Trigger
    
    func dateRequest(with components: DateComponents) -> Void {
        let content = UNMutableNotificationContent()
        content.title = "Todo completion time trigger"
        content.body = "Your time is up"
        content.sound = .default
        //notification badge always show 1 notification on app icon
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
        
        unCenter.add(request)
    }
    
}

extension NotificationService: UNUserNotificationCenterDelegate {
    //foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        completionHandler()
    }
    
    //background
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        
        let options: UNNotificationPresentationOptions = [.badge, .sound]
        completionHandler(options)
    }
}
