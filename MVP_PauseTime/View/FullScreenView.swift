//
//  FullScreenView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/20.
//

import SwiftUI

import SwiftUI

struct FullScreen: View {
    var closeAction: () -> Void

    var body: some View {
        VStack {
            Text("Break Time!")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("Your break starts now.")
                .foregroundColor(.white)
            Button("Close") {
                closeAction()
//                print("Close action triggered.")
            }
            .padding()
            .foregroundColor(.white) // Text color
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.75))
        .edgesIgnoringSafeArea(.all)
    }
}


struct FullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreen() {
//            print("Close action triggered.")
        }
    }
}
