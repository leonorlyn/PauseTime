//
//  SessionManager.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/15.
//

import Foundation


class SessionManager: ObservableObject {
    @Published var sessions: [Session] = []

    func startSession(type: SessionType) {
        let newSession = Session(startTime: Date(), endTime: Date(), type: type)
        sessions.append(newSession)
//        print("Started \(type) session at \(newSession.startTime)")
        saveSessions()
    }

    func endSession() {
        guard let lastSession = sessions.last else { return }
        sessions[sessions.count - 1].endTime = Date()
    }
    
    private func setupMidnightReset() {
        let calendar = Calendar.current
        let now = Date()
        let midnight = calendar.startOfDay(for: now)
        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: midnight)!
        
        timer = Timer.publish(every: nextMidnight.timeIntervalSinceNow, interval: 86400, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.cleanupOldSessions()
            }
    }

    var totalWorkTime: TimeInterval {
        sessions.filter { $0.type == .work }.reduce(0) { $0 + $1.duration }
    }

    var totalRestTime: TimeInterval {
        sessions.filter { $0.type == .break }.reduce(0) { $0 + $1.duration }
    }
    
    
}

struct Session : Hashable {
    var startTime: Date
    var endTime: Date
    var type: SessionType

    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(startTime)
        hasher.combine(endTime)
        hasher.combine(type)
    }

    static func ==(lhs: Session, rhs: Session) -> Bool {
        return lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime && lhs.type == rhs.type
    }
}

enum SessionType: String {
    case `work`
    case `break`
    case `inactive`
}
