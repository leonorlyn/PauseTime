//
//  MVP_PauseTimeApp.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/11.
//





import SwiftUI
import UserNotifications
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}

@main
struct MVP_PauseTimeApp: App {
    var countManager = CountManager()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // for the authorization
    init() {
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(countManager)
        }
    }
}


