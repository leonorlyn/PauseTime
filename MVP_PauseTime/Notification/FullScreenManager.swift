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
    }
    
    func dismissFullScreenNotification() {
        // 关闭窗口并清理引用
        print("Attempting to close full screen window...")
        if let window = fullScreenWindow {
            print("Closing window now...")
            window.isReleasedWhenClosed = false
            window.close()
            fullScreenWindow = nil
        }

        print("Full screen window closed.")
    }
}
