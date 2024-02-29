//
//  HomeView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/14.
//

import SwiftUI

struct HomeView : View{
    let workDuration = 1
    let breakDuration = 10
    
    @State public var remainingTime: Int
    @State private var timeActive = false
    @State private var onBreak = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        // Initialize remainingTime with the work duration
        _remainingTime = State(initialValue: workDuration)
    }
    
    var body: some View{
        VStack {
            Text(onBreak ? "BreakTime" : "WorkTime")
                .font(.headline)
            
            Text("\(timeString(from : remainingTime))")
                .font(.largeTitle)
                .onReceive(timer){ _ in
                    if self.timeActive{
                        if self.remainingTime > 0{
                            self.remainingTime -= 1
                        }else{
                            // Inside your HomeView, when the timer finishes:
                            if let notificationType = NotificationType(rawValue: UserDefaults.standard.string(forKey: "notificationType") ?? "") {
                                print(notificationType)
                                switch notificationType {
                                case .notification:
                                    NotificationManager.shared.scheduleNotification(type: .notification, title: "Break Time", body: "Your break starts now.")
                                case .fullScreen:
                                    FullScreenManager.shared.scheduleFullScreenNotification()
                                }
                            }
                            self.onBreak.toggle()
                            self.remainingTime = self.onBreak ? self.breakDuration : self.workDuration
                        }
                    }
                }
                .padding()
            
            
            // define the button action pause/start
            Button(action: {
                self.timeActive.toggle()
            }) {
                Text(timeActive ? "Pause" : "Start")
                    .padding()
            }
//            .background(timeActive ? Color.red : Color.green)
            .padding()
        }
        .padding()

    }
    
    
    
    // Helper function to format the remaining time into a string
         func timeString(from totalSeconds: Int) -> String{
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
