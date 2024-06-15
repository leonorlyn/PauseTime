//
//  DebugView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/23.
//

import SwiftUI

struct DebugView: View {
    @State private var isButtonActive = false  // Button state for demonstration

    var body: some View {
        Button(action: {
            // Toggle the state or perform any action
            isButtonActive.toggle()
        }) {
            Text(isButtonActive ? "Pause" : "Start")
                
                .foregroundColor(.black)
        }
        .animation(.easeInOut, value: isButtonActive)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.black, lineWidth: 1) // Black border
        )
    }
}

struct SimplifiedButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}



//struct DebugView: View {
//    @ObservedObject var sessionManager: SessionManager
//
//    var body: some View {
//
//        VStack {
//            WeekBarChartView(sessionManager: sessionManager)
//        }
//    }
//}
