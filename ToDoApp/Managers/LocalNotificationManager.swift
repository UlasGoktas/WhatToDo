//
//  NotificationService.swift
//  ToDoApp
//
//  Created by ulas on 14.10.2021.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotificationManager: NSObject {
    
    private override init() {}
    static let shared = LocalNotificationManager()
    
    let center = UNUserNotificationCenter.current()
    
    //MARK: - Notification Content
    
    func authorize() -> Void {
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) { granted, error in
            
            print(error?.localizedDescription ?? "Authorization error")
            
            guard granted else {
                print("User denied notification permission")
                return
            }
            self.configure()
        }
        
    }
    
    func configure() -> Void {
        center.delegate = self
        
    }
    
    //MARK: - Notification Trigger
    
    func dateRequest(with components: DateComponents) -> Void {
        let content = UNMutableNotificationContent()
        content.title = "Todo completion time trigger"
        content.body = "Your time is up"
        content.sound = .default
        //notification badge always show 1 notification on app icon
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
        
        center.add(request)
    }
    
}

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
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
