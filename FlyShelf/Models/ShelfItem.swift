// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI
import UniformTypeIdentifiers

struct ShelfItem: Identifiable, Hashable {
    let id: UUID
    let originalURL: URL
    let name: String
    let contentType: UTType
    let thumbnail: NSImage?
    
    init(url: URL) {
        self.id = UUID()
        self.originalURL = url
        self.name = url.lastPathComponent
        self.contentType = UTType(filenameExtension: url.pathExtension) ?? .data
        self.thumbnail = NSWorkspace.shared.icon(forFile: url.path)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ShelfItem, rhs: ShelfItem) -> Bool {
        lhs.id == rhs.id
    }
}
