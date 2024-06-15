//
//  CountManager.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/23.
//

import Foundation

class CountManager: ObservableObject {
    @Published var historicalCounts: [String: [String: Int]] = [:] {
        didSet {
            saveHistoricalCounts()  // Save anytime it changes
        }
    }
    
    // Computed properties for today's counts
    var todayWork: Int {
        todayCounts["work"] ?? 0
    }

    var todayBreak: Int {
        todayCounts["break"] ?? 0
    }

    var todaySkip: Int {
        todayCounts["skip"] ?? 0
    }

    private var todayCounts: [String: Int] {
        historicalCounts[todayString] ?? ["work": 0, "break": 0, "skip": 0]
    }
    
    private var todayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    init() {
        loadHistoricalCounts()
        print(todayWork)
    }
    
    func updateWorkCount() {
        updateCount(for: "work")
    }

    func updateBreakCount() {
        updateCount(for: "break")
    }

    func updateSkipCount() {
        updateCount(for: "skip")
    }

    private func updateCount(for type: String) {
        if historicalCounts[todayString] == nil {
            historicalCounts[todayString] = ["work": 0, "break": 0, "skip": 0]
        }
        historicalCounts[todayString]?[type, default: 0] += 1
    }
    
    private func saveHistoricalCounts() {
        do {
            let data = try JSONEncoder().encode(historicalCounts)
            UserDefaults.standard.set(data, forKey: "historicalCounts")
        } catch {
            print("Failed to save historical counts: \(error)")
        }
    }
    
    private func loadHistoricalCounts() {
        guard let data = UserDefaults.standard.data(forKey: "historicalCounts"),
              let loadedCounts = try? JSONDecoder().decode([String: [String: Int]].self, from: data) else {
            return
        }
        historicalCounts = loadedCounts
    }
}
