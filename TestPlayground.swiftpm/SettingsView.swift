import SwiftUI

struct SettingsView: View {
    @State private var isVibrationEnabled = true
    @State private var areSoundsEnabled = true
    @State private var areNotificationsEnabled = true

    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section() {
                        Toggle("Vibration", isOn: $isVibrationEnabled)
                        Toggle("Sounds", isOn: $areSoundsEnabled)
                        Toggle("Notifications", isOn: $areNotificationsEnabled)
                    }
                }
                .navigationTitle("Settings")
            }
            Spacer() // Questo spaziatore assicura che il testo sia in fondo.
            Text("Made by Michele Colella of the Apple Developer Academy in Naples")
                .padding()
        }
    }
}
