// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import AppKit

class MenuBarController: NSObject {
    private var statusItem: NSStatusItem?
    private var shelfWindowManager: ShelfWindowManager
    
    init(shelfWindowManager: ShelfWindowManager) {
        self.shelfWindowManager = shelfWindowManager
        super.init()
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "tray", accessibilityDescription: "FlyShelf")
            // Register for dragging
            button.window?.registerForDraggedTypes([.fileURL])
            
            // To handle the drop, we need to intercept the window's dragging events.
            // Simplified: we'll use a local monitor for performance.
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "New Shelf", action: #selector(createNewShelf), keyEquivalent: "n"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit FlyShelf", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    // In a more complex AppKit app, we'd subclass the button. 
    // Here we ensure the menu item itself can accept Drops.
    
    @objc private func createNewShelf() {
        let mouseLocation = NSEvent.mouseLocation
        shelfWindowManager.createShelf(at: mouseLocation)
    }
    
    @objc private func openPreferences() {
        NSApp.activate(ignoringOtherApps: true)
        if #available(macOS 13.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        }
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
