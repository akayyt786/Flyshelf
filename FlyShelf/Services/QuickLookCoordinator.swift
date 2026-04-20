// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI
import QuickLookUI

struct QuickLookPreview: NSViewRepresentable {
    let url: URL
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // This is a simplified wrapper. 
        // In a real app, you'd bind this to the QLPreviewPanel.shared()
    }
}

class QuickLookCoordinator: NSObject, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    static let shared = QuickLookCoordinator()
    var currentURL: URL?
    
    func showPreview(url: URL) {
        self.currentURL = url
        if let panel = QLPreviewPanel.shared() {
            panel.dataSource = self
            panel.delegate = self
            panel.makeKeyAndOrderFront(nil)
        }
    }
    
    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return currentURL != nil ? 1 : 0
    }
    
    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return currentURL as QLPreviewItem?
    }
}
