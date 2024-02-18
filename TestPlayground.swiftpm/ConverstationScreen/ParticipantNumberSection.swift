import SwiftUI

struct ParticipantNumberSection: View {
    @Binding var numberOfParticipants: Int
    private var participantOptions: [Int] {
        Array(1...10) // Assumendo un massimo di 10 partecipanti
    }

    var body: some View {
        Picker("No. of participants", selection: $numberOfParticipants) {
            ForEach(participantOptions, id: \.self) { option in
                Text("\(option)").tag(option)
            }
        }
    }
}
