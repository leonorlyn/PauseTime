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
    private var fullScreenWindows: [NSWindow] = []  // Changed to manage multiple windows
    var onDismissFullScreenNotification: (() -> Void)?

    func scheduleFullScreenNotification() {
        clearAllWindows()  // Clear any existing windows first

        NSScreen.screens.forEach { screen in  // Iterate over each screen
            let window = NSWindow(contentRect: screen.frame, styleMask: [.borderless], backing: .buffered, defer: false)
            window.level = .floating
            window.isOpaque = false
            window.backgroundColor = NSColor.clear
            window.contentView = NSHostingView(rootView: FullScreen(closeAction: {
                self.dismissFullScreenNotification()
            }))

            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            
            fullScreenWindows.append(window)  // Store the window reference
        }
        
        resetAutoDismissTimer()
    }
    
    func dismissFullScreenNotification() {
        fullScreenWindows.forEach { window in
            window.isReleasedWhenClosed = false
            window.close()  // Close each window
        }
        fullScreenWindows.removeAll()  // Clear the list of windows
        onDismissFullScreenNotification?()
        autoDismissTimer?.invalidate()
        autoDismissTimer = nil
    }

    func resetAutoDismissTimer() {
        autoDismissTimer?.invalidate()
        autoDismissTimer = Timer.scheduledTimer(withTimeInterval: Double(AppSettings.shared.breakTime * 60), repeats: false) { [weak self] _ in
            self?.dismissFullScreenNotification()
        }
    }

    private func clearAllWindows() {
        fullScreenWindows.forEach { $0.close() }
        fullScreenWindows.removeAll()
    }
}
