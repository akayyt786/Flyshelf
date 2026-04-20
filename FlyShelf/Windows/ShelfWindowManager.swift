// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import AppKit
import SwiftUI

class ShelfWindowManager: NSObject, ObservableObject {
    @Published var activePanels: [ShelfPanel] = []
    @Published var shelves: [Shelf] = []
    
    // Multi-shelf tracking
    private var shelfMap: [UUID: ShelfPanel] = [:]
    
    override init() {
        super.init()
        self.shelves = PersistenceManager.shared.loadShelves()
        
        // Listen for global shortcut to bring all to front
        NotificationCenter.default.addObserver(self, selector: #selector(bringAllToFront), name: NSNotification.Name("BringAllShelvesToFront"), object: nil)
    }
    
    @objc func bringAllToFront() {
        for panel in activePanels {
            panel.orderFrontRegardless()
        }
    }
    
    func createShelf(at location: NSPoint) {
        let newShelf = Shelf(position: location)
        shelves.append(newShelf)
        PersistenceManager.shared.saveShelves(shelves)
        
        let contentRect = NSRect(x: location.x, y: location.y, width: 300, height: 120)
        
        let shelfView = AnyView(
            ShelfContentView()
                .environmentObject(self)
        )
        
        let panel = ShelfPanel(contentRect: contentRect, rootView: shelfView)
        panel.makeKeyAndOrderFront(nil)
        
        activePanels.append(panel)
        
        // Initial animation
        panel.alphaValue = 0
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            panel.animator().alphaValue = 1
        }
    }
    
    func closeShelf(_ panel: ShelfPanel) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            panel.animator().alphaValue = 0
        }, completionHandler: {
            panel.close()
            if let index = self.activePanels.firstIndex(where: { $0 === panel }) {
                self.activePanels.remove(at: index)
                // In a real app, we'd also update the persisted 'shelves' array here
            }
        })
    }
}
