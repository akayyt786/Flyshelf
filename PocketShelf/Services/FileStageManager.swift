import Foundation

class FileStageManager {
    static let shared = FileStageManager()
    
    private let stagingURL: URL
    
    init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        stagingURL = paths[0].appendingPathComponent("PocketShelf/StagedFiles")
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
