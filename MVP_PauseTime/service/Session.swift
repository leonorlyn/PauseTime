//
//  Session.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/13.
//

import Foundation

struct Session {
    var startTime: Date
    var endTime: Date
    var type: SessionType

    // Computed property for duration
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }

    // Computed property to calculate start time position in a 24-hour timeline
    func startPosition(in totalWidth: CGFloat) -> CGFloat {
        let totalSeconds = 24 * 60 * 60  // total seconds in a day
        let secondsFromStartOfDay = startTime.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: TimeInterval(totalSeconds))
        return totalWidth * CGFloat(secondsFromStartOfDay / TimeInterval(totalSeconds))
    }

    // Computed property to calculate width of the rectangle in a 24-hour timeline
    func durationWidth(in totalWidth: CGFloat) -> CGFloat {
        let totalSeconds = 24 * 60 * 60  // total seconds in a day
        return totalWidth * CGFloat(duration / TimeInterval(totalSeconds))
    }
}

enum SessionType {
    case work
    case rest
}

