//CountdownTimerView
import SwiftUI
import Combine

struct CountdownTimerView: View {
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    @ObservedObject var audioRecorder = AudioRecorder()
    
    @Binding var title: String
    @Binding var note: String
    @Binding var playerNames: [String]
    @Binding var timerDuration: TimeInterval
    
    @State private var timeRemaining: TimeInterval
    @State private var currentPlayerIndex = 0
    @State private var allPlayersCompleted = false
    
    @State private var showContentView = false
    
    @State private var showExitConfirmation = false
    @State private var viewIsActive = true
    
    @State private var showButtons = false
    
    
    init(playerNames: Binding<[String]>, timerDuration: Binding<TimeInterval>, title: Binding<String>, note: Binding<String>) {
        _playerNames = playerNames
        _timerDuration = timerDuration
        _title = title
        _note = note
        _timeRemaining = State(initialValue: timerDuration.wrappedValue)
        
        //print("Nota inizializzata: \(note.wrappedValue)")
        
        // Inizializzazione del timer
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    private var isLargeScreen: Bool {
        UIScreen.main.bounds.width > 768
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CircleTimerView(timeRemaining: $timeRemaining, totalTime: timerDuration)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                VStack {
                    Text("It's \(playerNames[currentPlayerIndex])'s turn")
                        .font(isLargeScreen ? .system(size: 70) : .largeTitle)
                        .bold()
                        .padding()
                        .frame(width: geometry.size.width)
                        .padding(.top, geometry.safeAreaInsets.top)
                        .offset(y: 80)
                    
                    Spacer()
                    
                    if timeRemaining == 0 {
                        if currentPlayerIndex < playerNames.count - 1 {
                            Button("Next", action: nextPlayer)
                                .padding()
                                .buttonStyle(NextButtonStyle())
                                .transition(.opacity)
                                .offset(y: -70).bold()
                        } else {
                            Button("Save", action: saveAction)
                                .padding()
                                .buttonStyle(SaveButtonStyle())
                                .transition(.opacity)
                                .offset(y: -70).bold()
                            
                            NavigationLink("", destination: ContentView(), isActive: $showContentView)
                        }
                    }
                }
            }
        }
        .onAppear {
                    audioRecorder.startRecording()
                }
        .onReceive(timer) { _ in
            updateTimer()
        }
        
    }
    
    private func saveAction() {
        print("NOTE: \(note)")
        audioRecorder.stopRecording()

                    // Crea l'istanza di Conversation con tutti i dettagli, inclusa la registrazione
        let recordingURL = audioRecorder.recordings.last

                    let conversation = Conversation(
                        title: self.title,
                        participantNames: self.playerNames,
                        totalDuration: self.timerDuration * Double(self.playerNames.count),
                        notes: self.note,
                        lastUpdated: Date(),
                        recordingURL: recordingURL // Aggiunta del percorso della registrazione
                    )
        
        saveConversation(conversation)
        showContentView = true
    }
    
    private func saveConversation(_ conversation: Conversation) {
        do {
            // Ottieni il percorso della directory dei documenti
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // Crea un nome univoco per il file (ad esempio, basato sul timestamp)
            let timestamp = Date().timeIntervalSince1970
            let fileName = "Conversation_\(timestamp).json"
            
            // Aggiungi il nome del file alla struttura della conversazione (se necessario)
            var conversationToSave = conversation
            conversationToSave.fileName = fileName
            
            // Codifica la conversazione in formato JSON
            let data = try JSONEncoder().encode(conversationToSave)
            
            // Crea un URL completo per il file
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            // Scrivi i dati nel file
            try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
            
            // Stampa il percorso del file (opzionale, per scopi di debug)
            print("Conversazione salvata in: \(fileURL)")
        } catch {
            // Gestisci eventuali errori
            print("Errore durante il salvataggio: \(error)")
        }
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            withAnimation(.easeInOut(duration: 0.5)) {
                timer.upstream.connect().cancel()
                // Aggiungi qualsiasi altra logica necessaria qui
            }
        }
    }
    
    
    private func nextPlayer() {
        if currentPlayerIndex < playerNames.count - 1 {
            currentPlayerIndex += 1
            timeRemaining = timerDuration
            restartTimer() // Riavvia il timer
        } else {
            allPlayersCompleted = true
            timer.upstream.connect().cancel()
        }
    }
    
    
    private func restartTimer() {
        timer.upstream.connect().cancel() // Arresta il timer corrente
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Crea e avvia un nuovo timer
    }
    
    
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

struct CircleTimerView: View {
    @Binding var timeRemaining: TimeInterval
    let totalTime: TimeInterval
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenSize = UIScreen.main.bounds
            let circleSize = min(screenSize.width, screenSize.height) * 0.5
            
            ZStack {
                Circle()
                    .stroke(lineWidth: isLargeScreen ? 50 : 25)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining / totalTime))
                    .stroke(style: StrokeStyle(lineWidth: isLargeScreen ? 50 : 25, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.customColor)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: timeRemaining)
                
                Text(timeString(time: timeRemaining))
                    .font(isLargeScreen ? .system(size: 90) : .system(size: 50))
                
                Circle()
                    .fill(Color.clear)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                self.changeTimeRemaining(gesture: gesture, geometry: geometry)
                            }
                    )
            }
        }
        .frame(width: isLargeScreen ? 400 : 200, height: isLargeScreen ? 400 : 200)
    }
    
    private func changeTimeRemaining(gesture: DragGesture.Value, geometry: GeometryProxy) {
        let vector = CGVector(dx: gesture.location.x - geometry.size.width / 2, dy: gesture.location.y - geometry.size.height / 2)
        let angle = atan2(vector.dy, vector.dx)
        let fixedAngle = angle < 0 ? angle + 2 * .pi : angle
        let progress = fixedAngle / (2 * .pi)
        timeRemaining = TimeInterval(progress) * totalTime
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    private var isLargeScreen: Bool {
        UIScreen.main.bounds.width > 768
    }
}

struct NextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 100, height: 40) // Aumentato l'altezza per una migliore estetica
            .padding()
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .font(.title)
            .cornerRadius(10) // Aggiunto un raggio di angolo per bordi rotondi
            .overlay(
                RoundedRectangle(cornerRadius: 10) // Aggiunta una sovrapposizione di bordo
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: .gray, radius: 5, x: 0, y: 0) // Aggiunta un'ombra per un aspetto più tridimensionale
    }
}


struct SaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 100, height: 40) // Aumentato l'altezza per una migliore estetica
            .padding()
            .background(configuration.isPressed ? Color.gray : Color.green) // Modificato il colore di sfondo in verde
            .foregroundColor(.white)
            .font(.title)
            .cornerRadius(10) // Aggiunto un raggio di angolo per bordi rotondi
            .overlay(
                RoundedRectangle(cornerRadius: 10) // Aggiunta una sovrapposizione di bordo
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: .gray, radius: 5, x: 0, y: 0) // Aggiunta un'ombra per un aspetto più tridimensionale
    }
}


// Struttura per anteprima
struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimerView(playerNames: .constant(["Player1", "Player2", "Player3"]),
                           timerDuration: .constant(1), // 5 minuti
                           title: .constant("Example Conversation"),
                           note: .constant("This is a note for the conversation."))
    }
}
