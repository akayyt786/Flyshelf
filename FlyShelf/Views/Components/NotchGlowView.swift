// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI

struct NotchGlowView: View {
    @State private var isGlowing = false
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.clear]),
                center: .top,
                startRadius: 0,
                endRadius: 100
            )
            .frame(width: 300, height: 100)
            .opacity(isGlowing ? 1 : 0)
            .blur(radius: 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}
