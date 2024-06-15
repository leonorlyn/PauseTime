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
    @Published var onBreak: Bool // indicates work or break status
    private var nextWorkTime: Int?
    private var nextBreakTime: Int?
   
    var sessionManager = SessionManager()
    private var appSettings = AppSettings.shared // get info from appsetting
    private var timerSubscription: AnyCancellable? // optional timesubscription
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // initialize default worktime as remainingTime
        remainingTime = appSettings.workTime * 60
        timeActive = appSettings.timeActive
        onBreak = appSettings.onBreak
        nextWorkTime = appSettings.nextWorkTime
        nextBreakTime = appSettings.nextBreakTime
        setupSubscriptions()
    }
    
    func toggleTimeActive() {
        timeActive.toggle()
        if timeActive {
            // Start a new session
            let sessionType: SessionType = onBreak ? .break : .work
            sessionManager.startSession(type: sessionType)
        } else {
            // End the current session
            sessionManager.endSession()        }
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
    
    func skipBreak() {
        DispatchQueue.main.async {
            self.onBreak = false
            self.remainingTime = self.appSettings.workTime * 60
            self.timeActive = true  // Automatically restart work time
            self.sessionManager.setAsSkipSession()
            self.sessionManager.endSession()
            self.sessionManager.startSession(type: .work)
        }
    }
    
    func switchMode() {
        sessionManager.endSession()
        self.onBreak.toggle() //switch mode
        let nextTime = onBreak ? (nextBreakTime ?? appSettings.breakTime) : (nextWorkTime ?? appSettings.workTime)
        sessionManager.startSession(type: onBreak ? .break : .work) // record the new session
        print("break类型:\(onBreak)")
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
                    self.skipBreak()
                }
            }
        }
        nextWorkTime = nil
        nextBreakTime = nil
    }
}
