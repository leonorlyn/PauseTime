//
//  SessionManager.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/15.
//

import Foundation

class SessionManager: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var todaySessions: [Session] = []
    @Published var historicalCounts: [String: [String: Int]] = [:]
    @Published var weeklyData: [String: [SessionType: TimeInterval]] = [:]
    var countManager = CountManager()
    
    init() {
        loadSessions()  // Load sessions when the manager is initialized
        updateTodaySessions()
        aggregateDataForWeek()
//        sessions = []
    }
    
    
    private func updateTodaySessions() {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        todaySessions = sessions.filter { $0.startTime >= startOfToday }
    }
    
    func startSession(type: SessionType) {
        let newSession = Session(startTime: Date(), endTime: Date(), type: type)
        sessions.append(newSession)
    }
    
    func endSession() {
        // if the lasting time no more than 30s no add it
        guard var lastSession = sessions.last else { return }
        lastSession.endTime = Date()
        let duration = lastSession.endTime.timeIntervalSince(lastSession.startTime)

        if duration >= 30 {
            // Update the last session only if the duration is 30 seconds or more
            sessions[sessions.count - 1] = lastSession
            saveSessions()  // Save when a session ends
            updateCount(for: lastSession.type)
        } else {
            // Remove the session if the duration is less than 30 seconds
            sessions.removeLast()
        }
    }
    
    private func updateCount(for type: SessionType) {
        switch type {
        case .work:
            countManager.updateWorkCount()
        case .break:
            countManager.updateBreakCount()
        case .skip:
            countManager.updateSkipCount()
        }
    }
        
    func setAsSkipSession(){
        guard !sessions.isEmpty else { return }
        sessions[sessions.count - 1].type = .skip
    }
    
    func saveSessions() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "sessions")
        }
    }
    
    func loadSessions() {
        if let savedSessions = UserDefaults.standard.data(forKey: "sessions"),
           let decodedSessions = try? JSONDecoder().decode([Session].self, from: savedSessions) {
            sessions = decodedSessions
        }
    }
    
    func aggregateDataForWeek() {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"  // Format the date as a string

        for session in sessions {
            let day = calendar.startOfDay(for: session.startTime)
            let key = dateFormatter.string(from: day)
            
            if weeklyData[key] == nil {
                weeklyData[key] = [.work: 0, .break: 0, .skip: 0]
            }
            
            let duration = session.endTime.timeIntervalSince(session.startTime)
            weeklyData[key]?[session.type, default: 0] += duration
        }
        
        print("Weekly Data: \(weeklyData)")
    }


    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var weekDates: [String] {
        var dates = [String]()
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = weekday - calendar.firstWeekday
        let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!

        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                let dateString = dateFormatter.string(from: date)
                dates.append(dateString)
            }
        }
        return dates
    }

    
    struct Session: Codable, Hashable {
        var startTime: Date
        var endTime: Date
        var type: SessionType
        
        var duration: TimeInterval {
            endTime.timeIntervalSince(startTime)
        }
    }
}
