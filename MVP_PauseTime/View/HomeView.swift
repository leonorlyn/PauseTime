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
            mainTimerDisplay
            toggleButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var mainTimerDisplay: some View {
        Text(timeString(from: viewModel.remainingTime))
            .font(.system(size: 72))
            .padding(.vertical, 20)
    }
    
    private var toggleButton: some View {
        Button(action: {
            viewModel.toggleTimeActive()
        }) {
            Text(viewModel.timeActive ? "Pause" : "Start")
                .font(.system(size: 16))
                .padding(.horizontal, 25)
                .padding(.vertical, 13)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func timeString(from totalSeconds: Int) -> String {
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
