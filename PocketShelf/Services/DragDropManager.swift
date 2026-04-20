import SwiftUI
import UniformTypeIdentifiers

class DragDropManager: ObservableObject {
    @Published var items: [ShelfItem] = []
    
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        let group = DispatchGroup()
        
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                group.enter()
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (data, error) in
                    defer { group.leave() }
                    
                    if let urlData = data as? Data, let url = URL(dataRepresentation: urlData, relativeTo: nil) {
                        DispatchQueue.main.async {
                            self.addURL(url)
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    func addURL(_ url: URL) {
        let newItem = ShelfItem(url: url)
        if !items.contains(where: { $0.originalURL == url }) {
            items.append(newItem)
        }
    }
    
    func removeItem(_ item: ShelfItem) {
        items.removeAll { $0.id == item.id }
    }
}
