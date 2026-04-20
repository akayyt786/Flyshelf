import AppKit
import SwiftUI
import SwiftData

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?
    var shelfWindowManager: ShelfWindowManager?
    
    // Feature Detectors
    private let shakeDetector = ShakeDetector()
    private let shortcutManager = GlobalShortcutManager.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize managers
        let manager = ShelfWindowManager()
        self.shelfWindowManager = manager
        menuBarController = MenuBarController(shelfWindowManager: manager)
        
        // Hook up Shake to Open
        shakeDetector.onShakeDetected = {
            DispatchQueue.main.async {
                manager.createShelf(at: NSEvent.mouseLocation)
            }
        }
        shakeDetector.start()
        
        // Hook up Global Shortcut (Option+Shift+Space)
        shortcutManager.onShortcutPressed = {
            DispatchQueue.main.async {
                manager.createShelf(at: NSEvent.mouseLocation)
            }
        }
        shortcutManager.start()
        
        // Hook up Global Mouse Monitoring (Notch)
        GlobalMouseMonitor.shared.start()
        
        print("PocketShelf: Features activated.")
    }
}
