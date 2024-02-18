import SwiftUI

struct TimeSelectionSection: View {
    @Binding var selectedMinutes: Int
    @Binding var selectedSeconds: Int

    var body: some View {
        ZStack(alignment: .leading) {
            Text("Time for each participant")
                .padding(.vertical, 8)

            HStack {
                Spacer()
                PickerMenu(selection: $selectedMinutes, range: 0..<60, label: "Minuti")
                Text(":")
                PickerMenu(selection: $selectedSeconds, range: 0..<60, label: "Secondi")
            }
        }
    }
}
