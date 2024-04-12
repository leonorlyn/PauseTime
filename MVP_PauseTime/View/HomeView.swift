//
//  HomeView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/14.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            Text(viewModel.onBreak ? "Break Time" : "Work Time")
                .font(.headline)

            Text(timeString(from: viewModel.remainingTime))
                .font(.largeTitle)
                .padding()

            Button(action: {
                viewModel.toggleTimeActive()
            }) {
                Text(viewModel.timeActive ? "Pause" : "Start")
                    .padding()
            }
            .padding()
        }
        .padding()
    }

    private func timeString(from totalSeconds: Int) -> String {
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

struct Homeview_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
