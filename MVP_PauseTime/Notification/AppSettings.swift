//
//  AppSettings.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/3/4.
//

import Foundation

class AppSettings: ObservableObject {
    static let shared = AppSettings() // 单例

    @Published var breakTime: Int {
        didSet {
            UserDefaults.standard.set(breakTime, forKey: "breakTime")
        }
    }
    @Published var workTime: Int {
        didSet {
            UserDefaults.standard.set(workTime, forKey: "workTime")
        }
    }
    @Published var notificationType: NotificationType {
        didSet {
            UserDefaults.standard.set(notificationType.rawValue, forKey: "notificationType")
        }
    }

    private init() {
        // 从UserDefaults读取设置，如果不存在，则使用默认值
        self.breakTime = UserDefaults.standard.integer(forKey: "breakTime") != 0 ? UserDefaults.standard.integer(forKey: "breakTime") : 5
        self.workTime = UserDefaults.standard.integer(forKey: "workTime") != 0 ? UserDefaults.standard.integer(forKey: "workTime") : 25
        self.notificationType = NotificationType(rawValue: UserDefaults.standard.string(forKey: "notificationType") ?? NotificationType.notification.rawValue) ?? .notification
    }
    
    
}

enum NotificationType: String {
    case notification = "Notification"
    case fullScreen = "FullScreen"
}


