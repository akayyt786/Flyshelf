import Foundation

class FolderMonitor {
    private let url: URL
    private var descriptor: Int32 = -1
    private var source: DispatchSourceFileSystemObject?
    
    var onFileAdded: ((URL) -> Void)?
    
    init(url: URL) {
        self.url = url
    }
    
    func start() {
        descriptor = open(url.path, O_EVTONLY)
        guard descriptor != -1 else { return }
        
        source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: .write, queue: .main)
        
        source?.setEventHandler { [weak self] in
            // When a write event occurs, we should check for new files
            // For the blueprint, we acknowledge the triggering mechanism
            self?.checkForNewFiles()
        }
        
        source?.setCancelHandler { [weak self] in
            guard let self = self else { return }
            close(self.descriptor)
        }
        
        source?.resume()
    }
    
    func stop() {
        source?.cancel()
    }
    
    private func checkForNewFiles() {
        // Implementation to diff the directory and find the latest added file
        // Then call onFileAdded?(fileURL)
    }
}
