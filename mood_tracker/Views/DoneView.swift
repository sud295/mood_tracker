import SwiftUI
import SwiftData

struct DoneView: View {
    @Environment(\.modelContext) private var modelContext

    let mood: Int
    let responses: [String: Int]
    let onComplete: (_ savedAt: Date) -> Void

    @State private var isSaving = true
    @State private var errorText: String? = nil

    var body: some View {
        VStack(spacing: 18) {
            if isSaving {
                ProgressView("Saving…")
            } else if let errorText {
                Text("Failed to save")
                    .font(.title2)
                    .bold()
                Text(errorText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text("Saved!")
                    .font(.largeTitle)
                    .bold()
            }

            Button("Back to Home") {
                // even on error, let user go home (data is local-only, so error is unlikely)
                onComplete(Date())
            }
            .buttonStyle(.borderedProminent)
            .disabled(isSaving)
        }
        .padding()
        .onAppear {
            save()
        }
    }

    private func save() {
        let savedAt = Date()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responses, options: [.sortedKeys])
            let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"

            let m = Measurement(createdAt: savedAt, mood: mood, responsesJSON: jsonString)
            modelContext.insert(m)

            try modelContext.save()

            isSaving = false
            errorText = nil

            onComplete(savedAt)
        } catch {
            isSaving = false
            errorText = error.localizedDescription
        }
    }
}
