
//
//  SettingView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/14.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject private var viewModel: SettingViewModel

    init() {
        self.viewModel = SettingViewModel()
    }
    
    var body: some View {
        VStack {
            Picker("Notification Type", selection: $viewModel.notificationType) {
                Text("Sidebar Notification").tag(NotificationType.notification)
                Text("Full Screen Alert").tag(NotificationType.fullScreen)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            VStack(alignment: .leading) {
                Text("Work Time: \(Int(viewModel.workTime)) minutes")
                    .padding(.bottom, 2)
                Slider(value: $viewModel.workTime, in: 0...120, step: 1)
                    .accentColor(.blue)
            }
            .padding()

            VStack(alignment: .leading) {
                Text("Break Time: \(Int(viewModel.breakTime)) minutes")
                    .padding(.bottom, 2)
                Slider(value: $viewModel.breakTime, in: 1...120, step: 1)
                    .accentColor(.blue)
            }
            .padding()
        }
        .padding()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
