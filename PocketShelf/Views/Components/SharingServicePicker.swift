import SwiftUI
import AppKit

struct SharingServicePicker: NSViewRepresentable {
    @Binding var isPresented: Bool
    var items: [Any]
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if isPresented {
            let picker = NSSharingServicePicker(items: items)
            picker.delegate = context.coordinator
            
            // Show picker relative to the view
            DispatchQueue.main.async {
                picker.show(relativeTo: nsView.bounds, of: nsView, preferredEdge: .minY)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSSharingServicePickerDelegate {
        var parent: SharingServicePicker
        
        init(_ parent: SharingServicePicker) {
            self.parent = parent
        }
        
        func sharingServicePicker(_ picker: NSSharingServicePicker, didChoose service: NSSharingService?) {
            parent.isPresented = false
        }
    }
}
