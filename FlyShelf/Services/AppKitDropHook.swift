// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI
import AppKit

struct AppKitDropHook: NSViewRepresentable {
    let shelfID: UUID
    @ObservedObject var dragDrop: DragDropManager
    
    func makeNSView(context: Context) -> DropHookView {
        let view = DropHookView(shelfID: shelfID, dragDrop: dragDrop)
        return view
    }
    
    func updateNSView(_ nsView: DropHookView, context: Context) {}
}

class DropHookView: NSView {
    let shelfID: UUID
    let dragDrop: DragDropManager
    
    init(shelfID: UUID, dragDrop: DragDropManager) {
        self.shelfID = shelfID
        self.dragDrop = dragDrop
        super.init(frame: NSRect(x: 0, y: 0, width: 1, height: 1))
        
        // Register for all elite types including File Promises and standard images
        var types = NSFilePromiseReceiver.readableDraggedTypes.map { NSPasteboard.PasteboardType($0) }
        types.append(.fileURL)
        types.append(.URL)
        types.append(.string)
        types.append(.html)
        types.append(.png)
        types.append(.tiff)
        types.append(.pdf)
        registerForDraggedTypes(types)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if let window = self.window {
            self.frame = window.contentView?.bounds ?? .zero
            print("🚀 FlyShelf: DropHook activated. Window Bounds: \(self.frame)")
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("📁 FlyShelf: Drag entered view area")
        return .copy
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("📥 FlyShelf: Drop detected on hook")
        let pasteboard = sender.draggingPasteboard
        
        // 1. Handle File Promises
        if let promises = pasteboard.readObjects(forClasses: [NSFilePromiseReceiver.self], options: nil) as? [NSFilePromiseReceiver] {
            print("📜 FlyShelf: Detected \(promises.count) File Promises")
            for promise in promises {
                let dest = PersistenceManager.shared.getBlobsDirectory()
                promise.receivePromisedFiles(atDestination: dest, operationQueue: .main) { url, error in
                    print("✅ FlyShelf: Received file promise at \(url)")
                    DispatchQueue.main.async {
                        self.dragDrop.addURL(url)
                    }
                }
            }
        }
        
        // 2. Handle standard providers
        let providers = sender.draggingPasteboard.itemProviders
        if !providers.isEmpty {
            print("📦 FlyShelf: Handling \(providers.count) standard providers")
            DispatchQueue.main.async {
                _ = self.dragDrop.handleProviders(providers, shelfID: self.shelfID)
            }
        }
        
        return true
    }
    
    // Ensure clicks pass through to SwiftUI buttons unless a drag is in progress
    override func hitTest(_ point: NSPoint) -> NSView? {
        if NSApp.currentEvent?.type == .leftMouseDragged || NSEvent.pressedMouseButtons != 0 {
            return self
        }
        return nil
    }
}

extension NSPasteboard {
    var itemProviders: [NSItemProvider] {
        return self.readObjects(forClasses: [NSItemProvider.self], options: nil) as? [NSItemProvider] ?? []
    }
}
