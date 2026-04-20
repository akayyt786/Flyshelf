import Foundation
import AppKit

protocol ShelfAction {
    var name: String { get }
    var iconName: String { get }
    func execute(items: [ShelfItem]) async throws
}

struct AirDropAction: ShelfAction {
    let name = "AirDrop"
    let iconName = "square.and.arrow.up"
    
    func execute(items: [ShelfItem]) async throws {
        let urls = items.map { $0.originalURL }
        let picker = NSSharingServicePicker(items: urls)
        // This is tricky without a view reference, usually triggered via UI binding
    }
}

struct ZipAction: ShelfAction {
    let name = "Compress"
    let iconName = "archivebox"
    
    func execute(items: [ShelfItem]) async throws {
        // Implementation for zipping files
    }
}

class ActionExecutor {
    static let shared = ActionExecutor()
    
    func runAction(_ action: ShelfAction, on items: [ShelfItem]) {
        Task {
            do {
                try await action.execute(items: items)
            } catch {
                print("Action failed: \(error)")
            }
        }
    }
}
