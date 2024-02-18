import SwiftUI

struct ConversationCreation: View {
    @State private var selectedMinutes: Int = 0
    @State private var selectedSeconds: Int = 2
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var numberOfParticipants: Int = 2
    @State private var participantNotes: [String] = []
    
    @State private var isNavigationActive = false
    
    
    private var timeDuration: TimeInterval {
        TimeInterval(selectedMinutes * 60 + selectedSeconds)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Conversation data")) {
                    TextField("Title", text: $title)
                    ParticipantNumberSection(numberOfParticipants: $numberOfParticipants)
                    ParticipantNoteFields(numberOfParticipants: numberOfParticipants, participantNotes: $participantNotes)
                    TimeSelectionSection(selectedMinutes: $selectedMinutes, selectedSeconds: $selectedSeconds)
                    
                    NoteSection(note: $note)
                    
                }
                
                Button(action: {
                    // Imposta questa variabile a true per navigare
                    self.isNavigationActive = true
                }) {
                    Text("Start")
                        .bold()
                        .centered()
                        .foregroundColor(.green) // Imposta il colore del testo in verde
                }
                // Navigazione manuale
                .background(
                    NavigationLink(destination: CountdownTimerView(playerNames: $participantNotes, timerDuration: .constant(timeDuration), title: $title, note: $note), isActive: $isNavigationActive) {
                        EmptyView()
                    }
                        .hidden() // Nasconde la NavigationLink effettiva
                )
                
            }
            .navigationBarTitle("Conversation data", displayMode: .inline)
        }
    }
}
