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
                        DispatchQueue.main.async { self?.addLocalFile(url: url) }
                    }
                }
            } 
            // 2. Images (Elite Fix)
            else if provider.canLoadObject(ofClass: NSImage.self) {
                provider.loadObject(ofClass: NSImage.self) { [weak self] (image, error) in
                    if let image = image as? NSImage {
                        DispatchQueue.main.async { 
                            self?.addImageData(image: image)
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
                                    DispatchQueue.main.async {
                                        self?.addImageData(image: image)
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
                        DispatchQueue.main.async {
                            self?.addText(string: text)
                        }
                    }
                }
            }
        }
        return true
    }
    
    func addLocalFile(url: URL) {
        print("🔗 FlyShelf Manager: Adding File \(url.lastPathComponent)")
        let newItem = ShelfItem(url: url, type: .file)
        if !items.contains(where: { $0.originalURL == url }) {
            self.objectWillChange.send()
            items.append(newItem)
        }
    }
    
    func addImageData(image: NSImage) {
        print("🖼️ FlyShelf Manager: Adding Raw Image Data")
        let tempURL = PersistenceManager.shared.saveImageBlob(image)
        let newItem = ShelfItem(url: tempURL, type: .image, content: "Dropped Image")
        self.objectWillChange.send()
        items.append(newItem)
    }
    
    func addText(string: String) {
        print("📝 FlyShelf Manager: Adding Text Snippet")
        let tempURL = URL(string: "text://\(UUID().uuidString)")!
        let newItem = ShelfItem(url: tempURL, type: .text, content: string)
        self.objectWillChange.send()
        items.append(newItem)
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
