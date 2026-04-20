import AppKit

class GlobalShortcutManager {
    static let shared = GlobalShortcutManager()
    private var eventMonitor: Any?
    
    var onShortcutPressed: (() -> Void)?
    
    func start() {
        // Monitoring for Option + Shift + Space (default)
        // Note: Real apps use HOTKEY APIs or MASShortcut, 
        // here we use a global monitor for simplicity in the blueprint.
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            if event.modifierFlags.contains([.option, .shift]) && event.keyCode == 49 { // 49 is Space
                self?.onShortcutPressed?()
            }
        }
    }
    
    func stop() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
}
