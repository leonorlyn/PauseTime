//
//  AppSettings.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/3/4.
//

import Foundation

class AppSettings: ObservableObject {
    static let shared = AppSettings() // singleton pattern for  single access and data consistence

    // the break time
    @Published var breakTime: Int {
        didSet {
            UserDefaults.standard.set(breakTime, forKey: "breakTime")
        }
    }

    // the work time
    @Published var workTime: Int {
        didSet {
            UserDefaults.standard.set(workTime, forKey: "workTime")
        }
    }
    
    @Published var nextWorkTime: Int? { // Optional, will only be set if the timer is active
        didSet{
            if let wt = nextWorkTime{
                UserDefaults.standard.set(wt, forKey: "nextWorkTime")
            }
        }
    }
    
    @Published var nextBreakTime: Int? {
        didSet {
            if let bt = nextBreakTime {
                UserDefaults.standard.set(bt, forKey: "nextBreakTime")
            }
        }
    }


    
    @Published var timeActive = false //whether the timer is active
    
    @Published var onBreak = false //whether the timer is active
    
    @Published var notificationType: NotificationType {
        didSet {
            UserDefaults.standard.set(notificationType.rawValue, forKey: "notificationType")
        }
    }

    private init() {
        // In UserDefault, set default breaktime to 5, default worktime to 25, notificationType to notification
        // Use the previous setting preference exist, otherwise set the default value
        // this persist user settings: the previous set value remains even the app is restarted
        self.breakTime = UserDefaults.standard.integer(forKey: "breakTime") != 0 ? UserDefaults.standard.integer(forKey: "breakTime") : 5
        self.workTime = UserDefaults.standard.integer(forKey: "workTime") != 0 ? UserDefaults.standard.integer(forKey: "workTime") : 25
        self.notificationType = NotificationType(rawValue: UserDefaults.standard.string(forKey: "notificationType") ?? NotificationType.notification.rawValue) ?? .notification
    }
}

enum NotificationType: String {
    case notification = "Notification"
    case fullScreen = "FullScreen"
}


