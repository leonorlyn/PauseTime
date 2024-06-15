//
//  TimeChangeManager.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/21.
//

import Combine
import SwiftUI

class TimeChangeManager: ObservableObject {
    static let shared = TimeChangeManager()
    private var midnightTimer: AnyCancellable?
    private var lastCheckedDate = Calendar.current.startOfDay(for: Date())
    
    init() {
        setupMidnightTimer()
    }
    
    private func setupMidnightTimer() {
        midnightTimer = Timer.publish(every: 60 * 60, on: .main, in: .common)  // Check hourly
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkForDayChange()
            }
    }
    
    private func checkForDayChange() {
        let currentDay = Calendar.current.startOfDay(for: Date())
        if currentDay > lastCheckedDate {
            lastCheckedDate = currentDay
            NotificationCenter.default.post(name: .dayDidChange, object: nil)
        }
    }
}
