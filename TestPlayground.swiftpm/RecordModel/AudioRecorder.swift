import Foundation
import AVFoundation

class AudioRecorder: ObservableObject {
    var audioRecorder: AVAudioRecorder?
        @Published var recording = false

        // Aggiungi questa closure
        var onRecordingCompleted: ((URL) -> Void)?
        let settings: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatLinearPCM),
        AVSampleRateKey: 88200,
        AVNumberOfChannelsKey: 1,
        AVLinearPCMBitDepthKey: 16,
        AVLinearPCMIsBigEndianKey: false,
        AVLinearPCMIsFloatKey: false,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed setting up recording session")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let uniqueID = UUID().uuidString
        let audioFileName = docPath.appendingPathComponent("\(dateFormatter.string(from: Date()))_\(uniqueID).wav")

        do {
                    audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
                    audioRecorder?.record()
                    recording = true
                } catch {
                    print("Couldn't start recording: \(error.localizedDescription)")
                }
    }

    func stopRecording() {
            audioRecorder?.stop()
            recording = false
            if let url = audioRecorder?.url {
                // Chiamare la closure dopo aver fermato la registrazione
                onRecordingCompleted?(url)
            }
        }
}
