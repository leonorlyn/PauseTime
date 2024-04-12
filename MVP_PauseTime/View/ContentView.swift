//
//  ContentView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/11.
//

import SwiftUI

struct ContentView: View {
//    @StateObject private var homeViewModel = HomeViewModel()
    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel())
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
            DataView()
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
