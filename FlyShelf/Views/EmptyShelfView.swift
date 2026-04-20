// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
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
