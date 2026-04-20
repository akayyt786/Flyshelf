import SwiftUI

struct EmptyShelfView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus.square.dashed")
                .font(.system(size: 24))
                .foregroundColor(.secondary)
            Text("Drop files here")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
