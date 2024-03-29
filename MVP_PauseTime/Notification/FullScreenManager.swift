//
//  FullScreenManager.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/28.
//

import Foundation
import SwiftUI
import AppKit

class FullScreenManager {
    static let shared = FullScreenManager()
    private var autoDismissTimer: Timer?
    private var fullScreenWindow: NSWindow?
    
    func scheduleFullScreenNotification() {
        guard let mainScreen = NSScreen.main else { return }
        
        // 创建全屏窗口
        let window = NSWindow(contentRect: mainScreen.frame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.level = .floating
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.contentView = NSHostingView(rootView: FullScreen(closeAction: {
            self.dismissFullScreenNotification()
        }))
        
        // 显示窗口并激活应用
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        fullScreenWindow = window
        resetAutoDismissTimer()
    }
    
    func dismissFullScreenNotification() {
        if let window = fullScreenWindow {
            window.isReleasedWhenClosed = false
            window.close()
            fullScreenWindow = nil
        }
        // cancel timer
        autoDismissTimer?.invalidate()
        autoDismissTimer = nil
    }
    
    func resetAutoDismissTimer() {
        // cancel the current timer
        autoDismissTimer?.invalidate()
        // create a new timer
        autoDismissTimer = Timer.scheduledTimer(withTimeInterval: Double(AppSettings.shared.breakTime * 60), repeats: false) { [weak self] _ in
            self?.dismissFullScreenNotification()
        }
    }
}
