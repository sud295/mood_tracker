import Foundation
import SwiftData

@Model
final class Measurement {
    var id: UUID
    var createdAt: Date
    var mood: Int
    var responsesJSON: String

    // Sync metadata
    var synced: Bool
    var lastSyncAttemptAt: Date?
    var syncError: String?

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        mood: Int,
        responsesJSON: String,
        synced: Bool = false,
        lastSyncAttemptAt: Date? = nil,
        syncError: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.mood = mood
        self.responsesJSON = responsesJSON
        self.synced = synced
        self.lastSyncAttemptAt = lastSyncAttemptAt
        self.syncError = syncError
    }
}
