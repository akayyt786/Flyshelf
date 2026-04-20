// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import Foundation

class FileStageManager {
    static let shared = FileStageManager()
    
    private let stagingURL: URL
    
    init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        stagingURL = paths[0].appendingPathComponent("FlyShelf/StagedFiles")
        try? FileManager.default.createDirectory(at: stagingURL, withIntermediateDirectories: true)
    }
    
    func stageFile(at url: URL) -> URL? {
        let destination = stagingURL.appendingPathComponent(UUID().uuidString).appendingPathExtension(url.pathExtension)
        
        do {
            try FileManager.default.copyItem(at: url, to: destination)
            return destination
        } catch {
            print("Error staging file: \(error)")
            return nil
        }
    }
    
    func cleanUp() {
        try? FileManager.default.removeItem(at: stagingURL)
        try? FileManager.default.createDirectory(at: stagingURL, withIntermediateDirectories: true)
    }
}
