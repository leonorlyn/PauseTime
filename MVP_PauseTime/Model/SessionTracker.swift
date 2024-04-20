//
//  SessionTracker.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/13.
//

import Foundation


class SessionTracker: ObservableObject {
    @Published var sessions: [Session] = []

    func startSession(type: SessionType, at startTime: Date) {
        let newSession = Session(startTime: startTime, endTime: startTime, type: type) // endTime will be updated on endSession
        sessions.append(newSession)
        print("Session started: \(newSession)")
    }

    func endSession(at endTime: Date) {
        guard !sessions.isEmpty else { return }
        sessions[sessions.count - 1].endTime = endTime
    }
}
