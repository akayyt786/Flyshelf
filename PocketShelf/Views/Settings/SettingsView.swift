import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            
            ShortcutSettingsView()
                .tabItem {
                    Label("Shortcuts", systemImage: "keyboard")
                }
            
            PrivacyDashboardView()
                .tabItem {
                    Label("Privacy & AI", systemImage: "shield.lefthalf.filled")
                }
            
            ProSettingsView()
                .tabItem {
                    Label("Pro Mode", systemImage: "crown")
                }
        }
        .frame(width: 450, height: 350)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("shakeSensitivity") var sensitivity: Double = 0.5
    
    var body: some View {
        Form {
            Section("Gesture Sensitivity") {
                Slider(value: $sensitivity, in: 0...1) {
                    Text("Shake Sensitivity")
                } minimumValueLabel: {
                    Text("Low")
                } maximumValueLabel: {
                    Text("High")
                }
            }
        }
        .padding()
    }
}

struct ShortcutSettingsView: View {
    @AppStorage("activationShortcut") var shortcut: String = "Option + Shift + Space"
    
    var body: some View {
        Form {
            Section("Activation Shortcut") {
                HStack {
                    Text(shortcut)
                        .font(.system(size: 14, weight: .bold))
                        .padding(8)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(6)
                    
                    Button("Record New") {}
                }
            }
        }
        .padding()
    }
}

struct ProSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "crown.fill")
                .font(.system(size: 48))
                .foregroundColor(.yellow)
            
            Text("PocketShelf Pro")
                .font(.title2.bold())
            
            VStack(alignment: .leading, spacing: 8) {
                FeatureRow(text: "No interaction delay")
                FeatureRow(text: "Custom Actions")
                FeatureRow(text: "Unlimited Shelves")
            }
            
            Button("Upgrade for $6.99") {
                // Trigger purchase
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

struct FeatureRow: View {
    let text: String
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
        }
    }
}
