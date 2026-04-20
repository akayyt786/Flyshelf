// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import AppKit
import SwiftUI

class ShelfPanel: NSPanel {
    init(contentRect: NSRect, rootView: AnyView) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        self.isFloatingPanel = true
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = true
        
        let hostingView = NSHostingView(rootView: rootView)
        hostingView.frame = self.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]
        
        self.contentView = hostingView
    }
    
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    // Dragging logic for borderless window
    override func mouseDown(with event: NSEvent) {
        self.performDrag(with: event)
    }
    
    override func keyDown(with event: NSEvent) {
        // Handle common shortcuts
        switch event.keyCode {
        case 53: // Escape
            self.close()
        case 49: // Space
            // Trigger Quick Look (delegate to window manager)
            NotificationCenter.default.post(name: Notification.Name("QuickLookItem"), object: nil)
        case 123, 124, 125, 126: // Arrows
            // Navigate items
            NotificationCenter.default.post(name: NSNotification.Name("NavigateShelfItems"), object: event)
        default:
            super.keyDown(with: event)
        }
    }
}
