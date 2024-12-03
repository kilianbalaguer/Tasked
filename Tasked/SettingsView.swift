import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Button("Open Notification Settings") {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings)
                        }
                    }
                }
                Section(header: Text("About")) {
                    Text("Tasked App v0.0.1BETA")
                    Text("Created by Kilian Balaguer")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
