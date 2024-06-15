//
//  WeekBarChartView.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/4/26.
//

import SwiftUI

struct WeekBarChartView: View {
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) { // Adjust spacing as needed
                    ForEach(sessionManager.weekDates, id: \.self) { date in
                        VStack {
                            if let dayData = sessionManager.weeklyData[date] {
                                BarChartColumn(data: dayData, totalHeight: geometry.size.height - 20)
                            } else {
                                Text("No data")
                                    .frame(height: geometry.size.height - 20)
                            }
                            Spacer()
                            Text(date)
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal)
                .scaleEffect(0.9)
            }
        }
    }
    
    private func BarChartColumn(data: [SessionType: TimeInterval], totalHeight: CGFloat) -> some View {
        let maxDuration = data.values.max() ?? 1 // Avoid division by zero
        return GeometryReader { geo in // 使用 GeometryReader 获取父视图的尺寸
            ZStack(alignment: .bottom) { // 确保柱状图是底部对齐
                Rectangle() // 这是一个始终填充整个空间的透明背景
                    .foregroundColor(.clear)
                    .frame(width: geo.size.width, height: totalHeight)
                VStack(spacing: 0) {
                    ForEach(SessionType.allCases, id: \.self) { type in
                        if let duration = data[type], duration > 0 {
                            Rectangle()
                                .fill(color(for: type))
                                .frame(height: (CGFloat(duration) / CGFloat(maxDuration)) * totalHeight)
                                .cornerRadius(5) // Adds rounded corners
                                .shadow(radius: 2) // Adds shadow
                        }
                    }
                }
                .frame(width: geo.size.width, height: totalHeight, alignment: .bottom) // 确保整个 VStack 底部对齐
            }
        }
        .frame(height: totalHeight)
    }



    
    private func color(for type: SessionType) -> LinearGradient {
        let colors: [Color]
        switch type {
        case .work:
            colors = [.blue, .purple]
        case .break:
            colors = [.green, .yellow]
        case .skip:
            colors = [.red, .orange]
        }
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }
}

struct WeekBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeekBarChartView(sessionManager: SessionManager())
    }
}
