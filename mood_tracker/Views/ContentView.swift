import SwiftUI
import SwiftData
import Combine

enum AppStep {
    case gate
    case mood
    case questions
    case done
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var gateManager = GateManager()

    @StateObject private var syncManager = SyncManager(
        apiKey: AppSecrets.ingestApiKey
    )

    @State private var step: AppStep = .gate

    // Draft measurement data
    @State private var draftMood: Int = 0
    @State private var draftResponses: [String: Int] = [:]

    var body: some View {
        ZStack {
            switch step {
            case .gate:
                GateView(
                    gateManager: gateManager,
                    onStart: {
                        draftMood = 0
                        draftResponses = [:]
                        step = .mood
                    }
                )

            case .mood:
                MoodView(
                    mood: $draftMood,
                    onNext: { step = .questions },
                    onCancel: { step = .gate }
                )

            case .questions:
                QuestionsView(
                    responses: $draftResponses,
                    onFinish: { step = .done },
                    onCancel: { step = .gate }
                )

            case .done:
                DoneView(
                    mood: draftMood,
                    responses: draftResponses,
                    onComplete: { savedAt in
                        // Start the 1-hour cooldown after local save
                        gateManager.markCompleted(at: savedAt)
                        step = .gate

                        // Try syncing in the background (no UI blocking)
                        Task {
                            await syncManager.syncPending(modelContext: modelContext)
                        }
                    }
                )
            }
        }
        .onAppear {
            // Retry any pending syncs on app launch/return
            Task {
                await syncManager.syncPending(modelContext: modelContext)
            }
        }
    }
}
