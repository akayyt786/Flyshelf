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
        super.init(frame: .zero)
        
        // Register for all elite types including File Promises
        var types = NSFilePromiseReceiver.readableDraggedTypes.map { NSPasteboard.PasteboardType($0) }
        types.append(.fileURL)
        types.append(.URL)
        types.append(.string)
        types.append(.html)
        registerForDraggedTypes(types)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        
        // 1. Handle File Promises (The Elite Part)
        if let promises = pasteboard.readObjects(forClasses: [NSFilePromiseReceiver.self], options: nil) as? [NSFilePromiseReceiver] {
            for promise in promises {
                let dest = PersistenceManager.shared.getBlobsDirectory()
                promise.receivePromisedFiles(atDestination: dest, operationQueue: .main) { url, error in
                    // In some Swift versions url is non-optional
                    DispatchQueue.main.async {
                        self.dragDrop.addURL(url)
                    }
                }
            }
        }
        
        // 2. Handle standard providers (Fall back to DragDropManager logic)
        let providers = sender.draggingPasteboard.itemProviders
        if !providers.isEmpty {
            DispatchQueue.main.async {
                _ = self.dragDrop.handleProviders(providers, shelfID: self.shelfID)
            }
        }
        
        return true
    }
    
    // Ensure clicks pass through to SwiftUI buttons unless it's a drag
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
}

extension NSPasteboard {
    var itemProviders: [NSItemProvider] {
        return self.readObjects(forClasses: [NSItemProvider.self], options: nil) as? [NSItemProvider] ?? []
    }
}
