// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI

struct DetailListView: View {
    var items: [ShelfItem]
    
    var body: some View {
        List {
            ForEach(items) { item in
                HStack {
                    if let thumb = item.thumbnail {
                        Image(nsImage: thumb)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.system(size: 11, weight: .medium))
                        Text(item.contentType.localizedDescription)
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 2)
                .onDrag {
                    let provider = NSItemProvider()
                    if item.contentType == .text, let text = item.rawContent {
                        provider.registerObject(text as NSString, visibility: .all)
                    } else {
                        provider.registerObject(item.originalURL as NSURL, visibility: .all)
                    }
                    return provider
                }
            }
        }
        .listStyle(.plain)
        .frame(minHeight: 200)
    }
}
