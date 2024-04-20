//
//  ContentView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var homeViewModel = HomeViewModel()
//    @StateObject var sessionTracker = SessionTracker()
    var body: some View {
        TabView {
            HomeView(viewModel: homeViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
            DataView(sessions: homeViewModel.sessionManager.sessions)
                .tabItem {
                    Label("Activity", systemImage: "list.bullet")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
