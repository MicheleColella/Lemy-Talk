import SwiftUI

struct ParticipantNoteFields: View {
    let numberOfParticipants: Int
    @Binding var participantNotes: [String]

    var body: some View {
        ForEach(0..<numberOfParticipants, id: \.self) { index in
            TextField("Participant no. \(index + 1)", text: Binding(
                get: { participantNotes.indices.contains(index) ? participantNotes[index] : "" },
                set: { participantNotes.indices.contains(index) ? participantNotes[index] = $0 : participantNotes.append($0) }
            ))
        }
    }
}
