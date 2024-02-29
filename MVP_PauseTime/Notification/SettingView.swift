//
//  SettingView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/14.
//

import SwiftUI

struct SettingView : View{
    @AppStorage("notificationType") private var notificationType: NotificationType.RawValue = NotificationType.notification.rawValue
    
    var body: some View{
//        Text("settings")
//            .font(.headline)
//
    VStack {
        Picker("Notification Type", selection: $notificationType) {
            Text("Sidebar Notification").tag(NotificationType.notification.rawValue)
            Text("Full Screen Alert").tag(NotificationType.fullScreen.rawValue)
            }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        }
    .padding()
    }
}



enum NotificationType: String {
    case notification = "Notification"
    case fullScreen = "FullScreen"
}

struct Settingview: PreviewProvider{
    static var previews: some View{
        SettingView()
    }
}
