//
//  Dataview.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/14.
//

import SwiftUI


struct DataView: View {
    var sessions: [Session]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(sessions, id: \.self) { session in
                HStack {
                    Text("\(session.startTime, formatter: itemFormatter) - \(session.endTime, formatter: itemFormatter)")
                        .foregroundColor(.gray)
                    Text(session.type.rawValue.capitalized)
                        .padding(4)
                        .background(backgroundColor(for: session.type))
                        .cornerRadius(4)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
    }

    private func backgroundColor(for type: SessionType) -> Color {
        switch type {
        case .work:
            return .blue
        case .break:
            return .green
        case .inactive:
            return .gray
        }
    }

    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

