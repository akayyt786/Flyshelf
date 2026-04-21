// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI
import AppKit

struct AppKitDropHook: NSViewRepresentable {
    let shelfID: UUID
    @ObservedObject var dragDrop: DragDropManager
    @Binding var isTargeted: Bool
    
    func makeNSView(context: Context) -> DropHookView {
        let view = DropHookView(shelfID: shelfID, dragDrop: dragDrop)
        view.onTargetedChange = { targeted in
            DispatchQueue.main.async {
                self.isTargeted = targeted
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: DropHookView, context: Context) {}
}

class DropHookView: NSView {
    let shelfID: UUID
    let dragDrop: DragDropManager
    var onTargetedChange: ((Bool) -> Void)?
    
    init(shelfID: UUID, dragDrop: DragDropManager) {
        self.shelfID = shelfID
        self.dragDrop = dragDrop
        super.init(frame: NSRect(x: 0, y: 0, width: 1, height: 1))
        
        var types = NSFilePromiseReceiver.readableDraggedTypes.map { NSPasteboard.PasteboardType($0) }
        types.append(.fileURL)
        types.append(.URL)
        types.append(.string)
        types.append(.html)
        types.append(.png)
        types.append(.tiff)
        registerForDraggedTypes(types)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if let window = self.window {
            self.frame = window.contentView?.bounds ?? .zero
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        onTargetedChange?(true)
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        onTargetedChange?(false)
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        onTargetedChange?(false)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        
        // 1. Handle File Promises
        if let promises = pasteboard.readObjects(forClasses: [NSFilePromiseReceiver.self], options: nil) as? [NSFilePromiseReceiver], !promises.isEmpty {
            for promise in promises {
                let dest = PersistenceManager.shared.getBlobsDirectory()
                promise.receivePromisedFiles(atDestination: dest, operationQueue: .main) { url, error in
                    DispatchQueue.main.async {
                        self.dragDrop.addLocalFile(url: url)
                    }
                }
            }
            return true
        }
        
        // 2. Handle standard Files
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], !urls.isEmpty {
            for url in urls {
                DispatchQueue.main.async {
                    self.dragDrop.addLocalFile(url: url)
                }
            }
            return true
        }
        
        // 3. Handle Direct Images
        if let images = pasteboard.readObjects(forClasses: [NSImage.self], options: nil) as? [NSImage], !images.isEmpty {
            for image in images {
                DispatchQueue.main.async {
                    self.dragDrop.addImageData(image: image)
                }
            }
            return true
        }
        
        // 4. Handle Text
        if let strings = pasteboard.readObjects(forClasses: [NSString.self], options: nil) as? [String], !strings.isEmpty {
            for string in strings {
                DispatchQueue.main.async {
                    self.dragDrop.addText(string: string)
                }
            }
            return true
        }
        
        return true
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if NSApp.currentEvent?.type == .leftMouseDragged || NSEvent.pressedMouseButtons != 0 {
            return self
        }
        return nil
    }
}
