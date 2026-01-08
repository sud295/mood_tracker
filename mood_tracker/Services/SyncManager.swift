import Foundation
import SwiftData
import Combine

@MainActor
final class SyncManager: ObservableObject {
    private let userIdKey = "moodtracker_user_id"
    private let client: RemoteClient
    private(set) var userId: String

    private var isSyncing = false

    init(apiKey: String) {
        self.client = RemoteClient(apiKey: apiKey)

        if let existing = UserDefaults.standard.string(forKey: userIdKey) {
            self.userId = existing
        } else {
            let new = UUID().uuidString
            UserDefaults.standard.set(new, forKey: userIdKey)
            self.userId = new
        }
    }

    func syncPending(modelContext: ModelContext) async {
        guard !isSyncing else { return }
        isSyncing = true
        defer { isSyncing = false }

        let fd = FetchDescriptor<Measurement>(
            predicate: #Predicate { $0.synced == false },
            sortBy: [SortDescriptor(\.createdAt)]
        )

        let pending: [Measurement]
        do {
            pending = try modelContext.fetch(fd)
        } catch {
            print("SyncManager: fetch failed:", error)
            return
        }

        guard !pending.isEmpty else { return }

        let iso = ISO8601DateFormatter()

        for m in pending {
            m.lastSyncAttemptAt = Date()
            m.syncError = nil

            let responsesObj: Any = {
                guard let data = m.responsesJSON.data(using: .utf8),
                      let obj = try? JSONSerialization.jsonObject(with: data) else { return [:] }
                return obj
            }()

            let event: [String: Any] = [
                "event_type": "mood_measurement",
                "event_version": 1,
                "measurement_id": m.id.uuidString,
                "user_id": userId,
                "created_at_utc": iso.string(from: m.createdAt),
                "timezone": TimeZone.current.identifier,
                "mood": m.mood,
                "responses": responsesObj,
                "client": [
                    "platform": "ios",
                    "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "dev"
                ]
            ]

            do {
                try await client.postEvent(event)
                m.synced = true
                m.syncError = nil
            } catch {
                m.synced = false
                m.syncError = error.localizedDescription
            }

            do {
                try modelContext.save()
            } catch {
                print("SyncManager: save failed:", error)
            }
        }
    }
}
