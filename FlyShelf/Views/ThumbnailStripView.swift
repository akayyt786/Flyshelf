// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI

struct ThumbnailStripView: View {
    var items: [ShelfItem]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(items) { item in
                    ThumbnailView(item: item)
                }
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 80)
    }
}

struct ThumbnailView: View {
    var item: ShelfItem
    
    var body: some View {
        VStack(spacing: 4) {
            if let thumb = item.thumbnail {
                Image(nsImage: thumb)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(item.name)
                .font(.system(size: 9))
                .lineLimit(1)
                .frame(width: 60)
        }
        .draggable(item.originalURL) {
            // Drag Preview
            VStack {
                if let thumb = item.thumbnail {
                    Image(nsImage: thumb)
                        .resizable()
                        .frame(width: 64, height: 64)
                }
                Text(item.name)
                    .font(.caption)
                    .padding(4)
                    .background(.ultraThinMaterial)
                    .cornerRadius(4)
            }
        }
    }
}
