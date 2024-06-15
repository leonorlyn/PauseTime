//
//  ContentView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/11.
//

import SwiftUI

// 定义一个底部导航组件
struct FooterView: View {
    @Binding var selectedView: Int

    var body: some View {
        HStack {
            Button(action: {
                self.selectedView = 0
            }) {
                Label("主页", systemImage: "house")
            }
            Spacer()
            Button(action: {
                self.selectedView = 1
            }) {
                Label("功能一", systemImage: "1.circle")
            }
            Spacer()
            Button(action: {
                self.selectedView = 2
            }) {
                Label("功能二", systemImage: "2.circle")
            }
            Spacer()
            Button(action: {
                self.selectedView = 3
            }) {
                Label("功能三", systemImage: "3.circle")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1)) // 设置背景颜色，可以根据需要调整
    }
}

// 定义视图
struct ContentView: View {
    @State private var selectedView = 0
    @StateObject private var homeViewModel = HomeViewModel()
 

    var body: some View {
        VStack {
            Spacer()
            switch selectedView {
            case 1:
                SettingView()
            case 2:
                DataView(sessionManager: SessionManager(), countManager: CountManager())
            case 3:
                WeekBarChartView(sessionManager: SessionManager())
            default:
                HomeView(viewModel: homeViewModel)
            }
            Spacer()
            FooterView(selectedView: $selectedView)
        }
    }
}



//struct ContentView: View {
//    @StateObject private var homeViewModel = HomeViewModel()
//
//    var body: some View {
//        TabView {
//            HomeView(viewModel: homeViewModel)
//                .tabItem {
//                    Label("Home", systemImage: "house.fill")
//                }
//
//            SettingView()
//                .tabItem {
//                    Label("Settings", systemImage: "gearshape.fill")
//                }
//
//            DataView(sessionManager: SessionManager(), countManager: CountManager())
//                .tabItem {
//                    Label("Activity", systemImage: "chart.bar.fill")
//                }
//
//            DebugView()
//                .tabItem {
//                    Label("Debug", systemImage: "exclamationmark.triangle.fill")
//                }
//        }
//        .accentColor(.black) // 设置 Tab 图标和文字的选中颜色
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
