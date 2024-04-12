//
//  HomeViewModel.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/3/30.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    @Published var remainingTime: Int // remaining time for the current work or break clock
    @Published var timeActive: Bool
    @Published var onBreak = false // indicates work or break status
    
    
    private var appSettings = AppSettings.shared // get info from appsetting
    private var timerSubscription: AnyCancellable? // optional timesubscription
    private var cancellables = Set<AnyCancellable>()
    
    private var nextWorkTime: Int?
    private var nextBreakTime: Int?
    
    init() {
        // initialize default worktime as remainingTime
        remainingTime = appSettings.workTime * 60
        timeActive = appSettings.timeActive
        
        setupSubscriptions()
    }
    
    func toggleTimeActive() {
        timeActive.toggle()
    }
    
    //update time for timer
    private func updateTimer() {
        if timeActive {
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                switchMode()
            }
        }
    }
    
    private func setupSubscriptions() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.updateTimer()
        }

        // Observes changes in workTime and breakTime
        appSettings.$breakTime
            .sink { [weak self] newBreakTime in
                guard let self = self, self.onBreak else { return }
                if self.timeActive {
                    self.nextBreakTime = newBreakTime
                } else {
                    self.remainingTime = newBreakTime * 60
                }
            }
            .store(in: &cancellables)

        appSettings.$workTime
            .sink { [weak self] newWorkTime in
                guard let self = self, !self.onBreak else { return }
                if self.timeActive {
                    nextWorkTime = newWorkTime
                } else {
                    remainingTime = newWorkTime * 60
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleTimeChange(newTime: Int, isWorkTime: Bool) {
        if appSettings.timeActive {
            // If timer is active, store the value for later use
            if isWorkTime {
                nextWorkTime = newTime
            } else {
                nextBreakTime = newTime
            }
        } else {
            // If timer is inactive, update immediately
            remainingTime = newTime * 60
        }
    }
    
    func switchMode() {
        self.onBreak.toggle() //switch mode
        let nextTime = onBreak ? (nextBreakTime ?? appSettings.breakTime) : (nextWorkTime ?? appSettings.workTime)
        remainingTime = nextTime * 60

        
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
                FullScreenManager.shared.resetAutoDismissTimer()
                FullScreenManager.shared.onDismissFullScreenNotification = {
                    // if user skip break, update timer
                    DispatchQueue.main.async {
                        self.onBreak = false
                        self.remainingTime = self.appSettings.workTime * 60
                        self.timeActive = true // automatic start the work time
                    }
                }
            }
        }
        nextWorkTime = nil
        nextBreakTime = nil
    }
}