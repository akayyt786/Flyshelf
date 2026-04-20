// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI
import UniformTypeIdentifiers

struct ShelfItem: Identifiable, Codable, Hashable {
    let id: UUID
    let originalURL: URL
    let addedAt: Date
    var contentType: ContentType = .file
    var rawContent: String?
    
    var name: String {
        if contentType == .url { return rawContent ?? "Link" }
        if contentType == .text { return "Snippet" }
        return originalURL.lastPathComponent
    }
    
    var thumbnail: NSImage? {
        // This is now handled by the generator, but for backward compatibility in views:
        if contentType == .url { return NSImage(systemSymbolName: "link.circle.fill", accessibilityDescription: nil) }
        if contentType == .text { return NSImage(systemSymbolName: "doc.text.fill", accessibilityDescription: nil) }
        return NSWorkspace.shared.icon(forFile: originalURL.path)
    }
    
    enum ContentType: String, Codable {
        case file
        case url
        case text
        
        var localizedDescription: String {
            switch self {
            case .file: return "File"
            case .url: return "Web Link"
            case .text: return "Text Snippet"
            }
        }
    }
    
    init(id: UUID = UUID(), url: URL, type: ContentType = .file, content: String? = nil) {
        self.id = id
        self.originalURL = url
        self.addedAt = Date()
        self.contentType = type
        self.rawContent = content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ShelfItem, rhs: ShelfItem) -> Bool {
        lhs.id == rhs.id
    }
}
