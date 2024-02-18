import SwiftUI

struct NoteSection: View {
    @Binding var note: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if note.isEmpty {
                Text("Note")
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
            TextEditor(text: $note)
                .frame(minHeight: 100).offset(x: -2)
        }
    }
}

