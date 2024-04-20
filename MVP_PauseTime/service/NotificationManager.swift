//
//  NotificationManager.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/19.
//

import Foundation
import UserNotifications
import AppKit
import SwiftUI

class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
//                print("Notification permission granted.")
            } else if let error = error {
//                print("Notification permission denied due to \(error.localizedDescription).")
            }
        }
    }
    
    
    // Schedule a notification
    func scheduleNotification(type: NotificationType, title: String, body: String) {
//        print("Scheduling notification: \(title)")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false) // 5 seconds later as an example
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
//                print("Error scheduling notification: \(error)")
            }
        }
    }
    
}

