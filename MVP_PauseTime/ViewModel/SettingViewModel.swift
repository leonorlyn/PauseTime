//
//  SettingViewModel.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/9.
//

import Foundation

class SettingViewModel: ObservableObject {
    private var appSettings = AppSettings.shared
    
    init() {
        self.workTime = Double(appSettings.workTime)
        self.breakTime = Double(appSettings.breakTime)
        self.notificationType = appSettings.notificationType
        
    }

    @Published var workTime: Double {
        didSet {
            appSettings.workTime = Int(workTime)
        }
    }
    
    @Published var breakTime: Double {
        didSet {
            appSettings.breakTime = Int(breakTime)
            }
        }
    
    
    @Published var notificationType: NotificationType {
        didSet {
            appSettings.notificationType = notificationType
        }
    }
    
}

