// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import Foundation

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
}
