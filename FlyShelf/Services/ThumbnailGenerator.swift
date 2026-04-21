// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI
import QuickLookThumbnailing

class ThumbnailGenerator {
    static let shared = ThumbnailGenerator()
    
    func generateThumbnail(for url: URL, size: CGSize, completion: @escaping (NSImage?) -> Void) {
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: size,
            scale: NSScreen.main?.backingScaleFactor ?? 2.0,
            representationTypes: .thumbnail
        )
        
        QLThumbnailGenerator.shared.generateRepresentations(for: request) { (representation, type, error) in
            DispatchQueue.main.async {
                if let representation = representation {
                    completion(representation.nsImage)
                } else {
                    // Fallback to generic icon
                    completion(NSWorkspace.shared.icon(forFile: url.path))
                }
            }
        }
    }

    func generateThumbnail(for item: ShelfItem) async -> NSImage {
        switch item.contentType {
        case .image:
            if let image = NSImage(contentsOf: item.originalURL) {
                return image
            }
            return NSWorkspace.shared.icon(forFile: item.originalURL.path)
        case .file:
            return NSWorkspace.shared.icon(forFile: item.originalURL.path)
        case .url:
            return generateURLThumbnail(url: item.originalURL)
        case .text:
            return generateTextThumbnail(text: item.rawContent ?? "")
        }
    }
    
    private func generateURLThumbnail(url: URL) -> NSImage {
        // Return a stylized link icon
        return NSImage(systemSymbolName: "link.circle.fill", accessibilityDescription: "Web Link") ?? NSImage()
    }
    
    private func generateTextThumbnail(text: String) -> NSImage {
        // Return a stylized text snippet icon
        return NSImage(systemSymbolName: "doc.text.fill", accessibilityDescription: "Text Snippet") ?? NSImage()
    }
}
