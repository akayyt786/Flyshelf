// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import AppKit

class ShakeDetector: ObservableObject {
    private var eventMonitor: Any?
    private var lastX: CGFloat = 0
    private var directionChanges: Int = 0
    private var lastDirection: CGFloat = 0 // 1 for right, -1 for left
    private var lastChangeTime: Date = Date()
    
    var onShakeDetected: (() -> Void)?
    
    func start() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged]) { [weak self] event in
            self?.handleDrag(event)
        }
    }
    
    func stop() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    private func handleDrag(_ event: NSEvent) {
        let currentX = event.locationInWindow.x
        let deltaX = currentX - lastX
        let currentDirection = deltaX > 0 ? 1.0 : -1.0
        
        // Only count if displacement is significant
        if abs(deltaX) > 20 {
            if currentDirection != lastDirection {
                let now = Date()
                let interval = now.timeIntervalSince(lastChangeTime)
                
                if interval < 0.3 {
                    directionChanges += 1
                } else {
                    directionChanges = 1
                }
                
                lastDirection = currentDirection
                lastChangeTime = now
                
                if directionChanges >= 3 {
                    onShakeDetected?()
                    directionChanges = 0 // Reset after detection
                }
            }
        }
        
        lastX = currentX
    }
}
