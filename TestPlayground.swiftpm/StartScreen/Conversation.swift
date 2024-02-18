import Foundation

public struct Conversation: Codable, Hashable {
    var title: String
    var participantNames: [String]
    var totalDuration: TimeInterval
    var notes: String
    var lastUpdated: Date
    var fileName: String?
    var recordingURL: URL?
}
