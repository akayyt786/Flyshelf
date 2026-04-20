// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import SwiftUI

struct PrivacyDashboardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "cpu")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text("100% On-Device AI")
                        .font(.headline)
                    Text("Your files never leave your Mac.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Label("Privacy First", systemImage: "shield.checkered")
                Text("FlyShelf Pro uses Apple's Neural Engine to analyze files, generate smart names, and remove backgrounds. No data is sent to external servers.")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                
                Label("Local OCR", systemImage: "text.magnifyingglass")
                Text("Visual recognition is handled entirely by MacOS Vision framework.")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                
                Label("Transparent Intelligence", systemImage: "brain.head.profile")
                Text("Zero API keys, zero tracking, zero cloud costs.")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("Verified by Apple Hardware Security")
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(width: 400, height: 450)
    }
}
