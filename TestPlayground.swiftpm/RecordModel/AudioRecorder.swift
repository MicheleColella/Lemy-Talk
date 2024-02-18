import Foundation
import AVFoundation
import Combine

class AudioRecorder: ObservableObject {
    @Published var recordings: [URL] = []
    var audioRecorder: AVAudioRecorder?
    @Published var recording = false

    private var jsonFileURL: URL {
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docPath.appendingPathComponent("recordings.json")
    }

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
            recordings.append(audioFileName)
            saveRecordingsToFile()
        } catch {
            print("Couldn't start recording")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        recording = false
    }

    private func saveRecordingsToFile() {
        do {
            let data = try JSONEncoder().encode(recordings)
            try data.write(to: jsonFileURL)
        } catch {
            print("Failed to save recordings: \(error.localizedDescription)")
        }
    }

    func loadRecordingsFromFile() {
        do {
            let data = try Data(contentsOf: jsonFileURL)
            recordings = try JSONDecoder().decode([URL].self, from: data)
        } catch {
            print("Failed to load recordings: \(error.localizedDescription)")
        }
    }

    init() {
        loadRecordingsFromFile()
    }
}
