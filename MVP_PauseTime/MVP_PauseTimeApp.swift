//
//  MVP_PauseTimeApp.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/11.
//

import SwiftUI
import UserNotifications

@main
struct MVP_PauseTimeApp: App {
    // for the authorization
    init() {
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


