//
//  SessionTracker.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/13.
//

import Foundation

class SessionTracker: ObservableObject {
    @Published var totalScreenTime: TimeInterval = 0
    @Published var totalWorkTime: TimeInterval = 0
    @Published var totalRestTime: TimeInterval = 0

    private var sessionStartTime: Date?
    private var isWorkSession: Bool = true

    // Start a new session
    func startSession(isWork: Bool) {
        sessionStartTime = Date()  // Capture the current time as the start
        isWorkSession = isWork  // Set whether it's a work session or not
    }

    // End the current session
    func endSession() {
        guard let start = sessionStartTime else { return }
        let duration = Date().timeIntervalSince(start)  // Calculate duration

        if isWorkSession {
            totalWorkTime += duration  // Add to total work time if it's a work session
        } else {
            totalRestTime += duration  // Add to rest time otherwise
        }
        totalScreenTime += duration  // Always add to total screen time
    }
}
