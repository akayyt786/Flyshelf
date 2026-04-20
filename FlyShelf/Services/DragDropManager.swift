// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI
import UniformTypeIdentifiers

class DragDropManager: ObservableObject {
    @Published var items: [ShelfItem] = []
    
    func handleProviders(_ providers: [NSItemProvider], shelfID: UUID) -> Bool {
        let group = DispatchGroup()
        var newItems: [ShelfItem] = []
        
        for provider in providers {
            group.enter()
            
            // 1. Check for Files
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (urlData, error) in
                    if let data = urlData as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                        newItems.append(ShelfItem(url: url))
                    }
                    group.leave()
                }
            } 
            // 2. Check for Web URLs
            else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                provider.loadObject(ofClass: NSURL.self) { (url, error) in
                    if let url = url as? URL {
                        newItems.append(ShelfItem(url: url, type: .url, content: url.absoluteString))
                    }
                    group.leave()
                }
            }
            // 3. Check for Text Snippets
            else if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                provider.loadObject(ofClass: NSString.self) { (text, error) in
                    if let text = text as? String {
                        // Create a temporary "Text" URL placeholder
                        let tempURL = URL(string: "text://\(UUID().uuidString)")!
                        newItems.append(ShelfItem(url: tempURL, type: .text, content: text))
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        return true
    }
    
    func addURL(_ url: URL) {
        let newItem = ShelfItem(url: url)
        if !items.contains(where: { $0.originalURL == url }) {
            items.append(newItem)
        }
    }
    
    func removeItem(_ item: ShelfItem) {
        items.removeAll { $0.id == item.id }
    }
}
