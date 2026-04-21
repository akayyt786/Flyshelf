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
            if !promises.isEmpty {
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
                return true
            }
        }
        
        // 2. Handle standard Files (Finder)
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            if !urls.isEmpty {
                print("📦 FlyShelf: Found \(urls.count) File URLs")
                for url in urls {
                    DispatchQueue.main.async {
                        self.dragDrop.addURL(url)
                    }
                }
                return true
            }
        }
        
        // 3. Handle Direct Images (Browsers)
        if let images = pasteboard.readObjects(forClasses: [NSImage.self], options: nil) as? [NSImage] {
            if !images.isEmpty {
                print("🖼️ FlyShelf: Found \(images.count) Raw Images")
                for image in images {
                    let tempURL = PersistenceManager.shared.saveImageBlob(image)
                    DispatchQueue.main.async {
                        self.dragDrop.addURL(tempURL)
                    }
                }
                return true
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
