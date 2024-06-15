//
//  DayCountView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/23.
//

import SwiftUI


struct DayCountView: View {
    @ObservedObject var countManager: CountManager
    
    var body: some View {
        VStack {
            Text("DayCountView: Work count is \(countManager.todayWork)")
            Text("Today's Counts")
            HStack {
                VStack {
                    Text("Work")
                    Text("\(countManager.todayWork)")
                }
                VStack {
                    Text("Break")
                    Text("\(countManager.todayBreak)")
                }
                VStack {
                    Text("Skip")
                    Text("\(countManager.todaySkip)")
                }
            }
        }
    }
}
