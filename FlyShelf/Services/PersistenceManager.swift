// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import Foundation
import AppKit

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let fileURL: URL
    
    init() {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupport = paths[0].appendingPathComponent("FlyShelf")
        try? FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
        fileURL = appSupport.appendingPathComponent("shelves.json")
    }
    
    func saveShelves(_ shelves: [Shelf]) {
        do {
            let data = try JSONEncoder().encode(shelves)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save shelves: \(error)")
        }
    }
    
    func loadShelves() -> [Shelf] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Shelf].self, from: data)
        } catch {
            return []
        }
    }
    
    func saveImageBlob(_ image: NSImage) -> URL {
        let appSupport = fileURL.deletingLastPathComponent()
        let blobsDir = appSupport.appendingPathComponent("Blobs")
        try? FileManager.default.createDirectory(at: blobsDir, withIntermediateDirectories: true)
        
        let fileName = "\(UUID().uuidString).png"
        let fileURL = blobsDir.appendingPathComponent(fileName)
        
        if let tiffData = image.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiffData),
           let data = bitmap.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) {
            try? data.write(to: fileURL)
        }
        
        return fileURL
    }
    
    func getBlobsDirectory() -> URL {
        let appSupport = fileURL.deletingLastPathComponent()
        let blobsDir = appSupport.appendingPathComponent("Blobs")
        try? FileManager.default.createDirectory(at: blobsDir, withIntermediateDirectories: true)
        return blobsDir
    }
}
