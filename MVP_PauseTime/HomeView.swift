//
//  HomeView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/14.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var appSettings = AppSettings.shared

    @State private var remainingTime: Int
    @State private var timeActive = false
    @State private var onBreak = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init() {
        // 初始化remainingTime为工作时间
        _remainingTime = State(initialValue: AppSettings.shared.workTime * 60)
    }

    var body: some View {
        VStack {
            Text(onBreak ? "Break Time" : "Work Time")
                .font(.headline)

            Text(timeString(from: remainingTime))
                .font(.largeTitle)
                .onReceive(timer) { _ in
                    if self.timeActive {
                        if self.remainingTime > 0 {
                            self.remainingTime -= 1
                        } else {
                            self.switchMode()
                        }
                    }
                }
                .onReceive(appSettings.$workTime) { newValue in
                    // 当工作时间改变时，如果当前不是在休息，则更新剩余时间
                    if !self.onBreak {
                        self.remainingTime = newValue * 60
                    }
                }
                .onReceive(appSettings.$breakTime) { newValue in
                    // 当休息时间改变时，如果当前在休息，则更新剩余时间
                    if self.onBreak {
                        self.remainingTime = newValue * 60
                    }
                }
                .padding()

            Button(action: {
                self.timeActive.toggle()
            }) {
                Text(timeActive ? "Pause" : "Start")
                    .padding()
            }
            .padding()
        }
        .padding()
    }

    func switchMode() {
        // Toggle between work and break time
        self.onBreak.toggle()
        
        // Update remainingTime based on the new state
        self.remainingTime = self.onBreak ? (self.appSettings.breakTime * 60) : (self.appSettings.workTime * 60)
        
        
        // Decide on notification type and show the appropriate notification
        if(self.onBreak){
            switch self.appSettings.notificationType {
            case .notification:
                // Call to NotificationManager to schedule a local notification
                let title = "Break Time"
                let body = "Time to take a break!"
                NotificationManager.shared.scheduleNotification(type: .notification, title: title, body: body)
            case .fullScreen:
                // Call to FullScreenManager to show a full-screen alert
                    FullScreenManager.shared.scheduleFullScreenNotification()
            }
        }
    }


    func timeString(from totalSeconds: Int) -> String {
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}


struct Homeview: PreviewProvider{
    static var previews: some View{
        HomeView()
    }
}
