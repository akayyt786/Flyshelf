import SwiftUI

struct InstantActionsView: View {
    @State private var isShowingSharingPicker = false
    var items: [ShelfItem]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Instant Actions")
                .font(.system(size: 13, weight: .bold))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ActionButton(name: "AirDrop", icon: "square.and.arrow.up") {
                    isShowingSharingPicker = true
                }
                
                ActionButton(name: "Mail", icon: "envelope") {
                    // Trigger mail
                }
                
                ActionButton(name: "Messages", icon: "message") {
                    // Trigger messages
                }
                
                ActionButton(name: "Compress", icon: "archivebox") {
                    // Trigger zip
                }
            }
        }
        .padding()
        .background(SharingServicePicker(isPresented: $isShowingSharingPicker, items: items.map { $0.originalURL }))
    }
}

struct ActionButton: View {
    let name: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(name)
                    .font(.system(size: 10))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.primary.opacity(0.05))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
