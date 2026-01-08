import SwiftUI
import SwiftData

enum AppStep {
    case gate
    case mood
    case questions
    case done
}

struct ContentView: View {
    @StateObject private var gateManager = GateManager()
    @State private var step: AppStep = .gate

    // Draft measurement data
    @State private var draftMood: Int = 0
    @State private var draftResponses: [String: Int] = [:]

    var body: some View {
        switch step {
        case .gate:
            GateView(
                gateManager: gateManager,
                onStart: {
                    // reset draft each time user starts
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
                    // Reset the 1-hour timer ONLY after we've recorded the measurement
                    gateManager.markCompleted(at: savedAt)

                    // Return home
                    step = .gate
                }
            )
        }
    }
}
