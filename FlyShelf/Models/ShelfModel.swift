// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import Foundation

struct Shelf: Identifiable, Codable {
    var id: UUID
    var name: String
    var colorTag: String
    var createdAt: Date
    var items: [ShelfItemReference]
    var positionX: Double
    var positionY: Double
    var isDocked: Bool
    
    init(id: UUID = UUID(), name: String = "Shelf", colorTag: String = "Blue", position: CGPoint = .zero) {
        self.id = id
        self.name = name
        self.colorTag = colorTag
        self.createdAt = Date()
        self.items = []
        self.positionX = Double(position.x)
        self.positionY = Double(position.y)
        self.isDocked = false
    }
}

struct ShelfItemReference: Identifiable, Codable {
    var id: UUID
    var name: String
    var originalPath: String
    var stagedPath: String
    var contentType: String
    var size: Int64
}
