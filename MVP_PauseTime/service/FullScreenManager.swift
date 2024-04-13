//
//  FullScreenManager.swift
//  MVP_PauseTime
//
//  Created by Leonora on 2024/2/28.
//
import Foundation
import SwiftUI
import AppKit
import Cocoa

class FullScreenManager {
    static let shared = FullScreenManager()
    private var autoDismissTimer: Timer?
    private var fullScreenWindows: [NSWindow] = []  // Changed to manage multiple windows
    var onDismissFullScreenNotification: (() -> Void)?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleActiveSpaceChange(_:)),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil)
    }

    
    @objc private func handleActiveSpaceChange(_ notification: Notification) {
        NSLog("Active space changed, reordering windows to front")
        fullScreenWindows.forEach { window in
            if NSApp.isActive {
                NSLog("Ordering window to front: \(window)")
                window.orderFrontRegardless()
            }
        }
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    func scheduleFullScreenNotification() {
//        clearAllWindows()  // Clear any existing windows first
        NSLog("Scheduling full-screen notifications on all screens")
        NSScreen.screens.forEach { screen in  // Iterate over each screen
            let window = NSWindow(contentRect: screen.frame, styleMask: [.borderless], backing: .buffered, defer: false)
            NSLog("Creating window on screen: \(screen.localizedName) with frame: \(screen.frame)")
            window.level = .screenSaver
            window.isOpaque = false
            window.backgroundColor = NSColor.clear
            window.contentView = NSHostingView(rootView: FullScreen(closeAction: {
                self.dismissFullScreenNotification()
            }))
            


            window.makeKeyAndOrderFront(nil)
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            NSApp.activate(ignoringOtherApps: true)
//            NSApplication.shared.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
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
