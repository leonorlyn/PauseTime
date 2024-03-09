
//
//  SettingView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/14.
//

import SwiftUI

struct SettingView : View{
    @ObservedObject private var appSettings = AppSettings.shared
    
    var body: some View {
        VStack {
            Picker("Notification Type", selection: $appSettings.notificationType) {
                Text("Sidebar Notification").tag(NotificationType.notification)
                Text("Full Screen Alert").tag(NotificationType.fullScreen)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField("Work Time (minutes)", value: $appSettings.workTime, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Break Time (minutes)", value: $appSettings.breakTime, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .padding()
    }
}

struct Settingview: PreviewProvider{
    static var previews: some View{
        SettingView()
    }
}
