import AppKit
import SwiftUI

class GlobalMouseMonitor: ObservableObject {
    static let shared = GlobalMouseMonitor()
    private var eventMonitor: Any?
    
    @Published var isNearNotch: Bool = false
    
    func start() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .leftMouseDragged]) { [weak self] event in
            self?.checkNotch(event)
        }
    }
    
    func stop() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    private func checkNotch(_ event: NSEvent) {
        let mouseLocation = NSEvent.mouseLocation
        let inNotch = NotchDetector.isPointInNotch(mouseLocation)
        
        if inNotch != isNearNotch {
            DispatchQueue.main.async {
                self.isNearNotch = inNotch
                if inNotch {
                    // Logic to show NotchGlowView could go here
                    print("Mouse entered notch region.")
                }
            }
        }
    }
}
