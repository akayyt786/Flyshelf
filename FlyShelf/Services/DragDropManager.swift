// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI
import UniformTypeIdentifiers

class DragDropManager: ObservableObject {
    @Published var items: [ShelfItem] = []
    
    func handleProviders(_ providers: [NSItemProvider], shelfID: UUID) -> Bool {
        for provider in providers {
            // 1. Files
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { [weak self] (urlData, error) in
                    if let data = urlData as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                        DispatchQueue.main.async { self?.addURL(url) }
                    }
                }
            } 
            // 2. Images (Elite Fix)
            else if provider.canLoadObject(ofClass: NSImage.self) {
                provider.loadObject(ofClass: NSImage.self) { [weak self] (image, error) in
                    if let image = image as? NSImage {
                        let tempURL = PersistenceManager.shared.saveImageBlob(image)
                        DispatchQueue.main.async { 
                            self?.items.append(ShelfItem(url: tempURL, type: .image, content: "Dropped Image"))
                        }
                    }
                }
            }
            // 3. URLs
            else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                provider.loadObject(ofClass: NSURL.self) { [weak self] (url, error) in
                    if let url = url as? URL {
                        if ["jpg", "jpeg", "png", "gif", "webp"].contains(url.pathExtension.lowercased()) {
                            Task {
                                if let image = await self?.downloadImage(from: url) {
                                    let tempURL = PersistenceManager.shared.saveImageBlob(image)
                                    DispatchQueue.main.async {
                                        self?.items.append(ShelfItem(url: tempURL, type: .image, content: url.absoluteString))
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self?.items.append(ShelfItem(url: url, type: .url, content: url.absoluteString))
                            }
                        }
                    }
                }
            }
            // 4. Text
            else if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                provider.loadObject(ofClass: NSString.self) { [weak self] (text, error) in
                    if let text = text as? String {
                        let tempURL = URL(string: "text://\(UUID().uuidString)")!
                        DispatchQueue.main.async {
                            self?.items.append(ShelfItem(url: tempURL, type: .text, content: text))
                        }
                    }
                }
            }
        }
        return true
    }
    
    func addURL(_ url: URL) {
        print("🔗 FlyShelf Manager: Adding URL \(url)")
        let newItem = ShelfItem(url: url)
        if !items.contains(where: { $0.originalURL == url }) {
            self.objectWillChange.send()
            items.append(newItem)
            print("✨ FlyShelf Manager: Item added successfully. Total items: \(items.count)")
        } else {
            print("⚠️ FlyShelf Manager: Item already exists in shelf")
        }
    }
    
    private func downloadImage(from url: URL) async -> NSImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return NSImage(data: data)
        } catch {
            print("Failed to download image: \(error)")
            return nil
        }
    }
    
    func removeItem(_ item: ShelfItem) {
        items.removeAll { $0.id == item.id }
    }
}
