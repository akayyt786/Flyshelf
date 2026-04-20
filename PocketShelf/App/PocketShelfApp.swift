import SwiftUI

@main
struct PocketShelfApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // No WindowGroup here because we manage windows manually via NSPanel
        Settings {
            SettingsView()
        }
    }
}
