// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI

struct ShelfContentView: View {
    @EnvironmentObject var windowManager: ShelfWindowManager
    @StateObject private var dragDrop = DragDropManager()
    @State private var isDetailViewExpanded = false
    private let shelfID = UUID()
    
    var body: some View {
        ZStack {
            VisualEffectBackground()
                .cornerRadius(10)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Circle()
                        .fill(dragDrop.items.isEmpty ? Color.gray : Color.blue)
                        .frame(width: 8, height: 8)
                    
                    Text(isDetailViewExpanded ? "All Items" : (dragDrop.items.isEmpty ? "FlyShelf" : "FlyShelf (\(dragDrop.items.count))"))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.primary.opacity(0.8))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                isDetailViewExpanded.toggle()
                            }
                        }
                    
                    Spacer()
                    
                    if !dragDrop.items.isEmpty {
                        Button(action: {
                            // Instant Actions toggle
                        }) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 10))
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 8)
                    }
                    
                    Button(action: {
                        // Find the panel associated with this window and close it
                        if let window = NSApp.keyWindow as? ShelfPanel {
                            windowManager.closeShelf(window)
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 10)
                .padding(.top, 8)
                .padding(.bottom, 4)
                
                // Content
                if dragDrop.items.isEmpty {
                    EmptyShelfView()
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else if isDetailViewExpanded {
                    DetailListView(items: dragDrop.items)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    ThumbnailStripView(items: dragDrop.items)
                        .transition(.opacity.combined(with: .scale(scale: 1.05)))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
        )
        .overlay(
            AppKitDropHook(shelfID: shelfID, dragDrop: dragDrop)
        )
    }
}
