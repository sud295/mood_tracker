import SwiftUI

struct Question: Identifiable {
    enum Kind {
        case yesNo
        case scale0to3
        case socialValence // -1 / 0 / +1
    }

    let id: String
    let text: String
    let kind: Kind
}

private let questionBank: [Question] = [
    .init(id: "sugar_past_hour", text: "Did you eat sugar in the past hour?", kind: .scale0to3),
    .init(id: "caffeine_past_hour", text: "Did you have caffeine in the past hour?", kind: .scale0to3),
    .init(id: "exercise_past_hour", text: "Did you exercise in the past hour?", kind: .scale0to3),
    .init(id: "stress_past_hour", text: "How stressful was the past hour?", kind: .scale0to3),
    .init(id: "social_valence_past_hour", text: "How was your social interaction in the past hour?", kind: .socialValence)
]

struct QuestionsView: View {
    @Binding var responses: [String: Int]
    var onFinish: () -> Void
    var onCancel: () -> Void

    @State private var index: Int = 0
    @State private var currentValue: Int = 0

    private var q: Question { questionBank[index] }

    var body: some View {
        VStack(spacing: 22) {
            Text("Question \(index + 1) of \(questionBank.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(q.text)
                .font(.title2)
                .multilineTextAlignment(.center)

            answerControl(for: q.kind)

            HStack(spacing: 12) {
                Button("Cancel") { onCancel() }
                    .buttonStyle(.bordered)

                Button(index == questionBank.count - 1 ? "Finish" : "Next") {
                    responses[q.id] = currentValue
                    advance()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .onAppear {
            // initialize currentValue from existing response if returning
            currentValue = responses[q.id] ?? defaultValue(for: q.kind)
        }
    }

    @ViewBuilder
    private func answerControl(for kind: Question.Kind) -> some View {
        switch kind {
        case .yesNo:
            Picker("Answer", selection: $currentValue) {
                Text("No").tag(0)
                Text("Yes").tag(1)
            }
            .pickerStyle(.segmented)

        case .scale0to3:
            VStack(spacing: 12) {
                Text("\(currentValue)")
                    .font(.system(size: 44, weight: .bold))
                    .monospacedDigit()

                Slider(
                    value: Binding(
                        get: { Double(currentValue) },
                        set: { currentValue = Int($0) }
                    ),
                    in: 0...3,
                    step: 1
                )

                Text("0 = none, 3 = a lot")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

        case .socialValence:
            Picker("Social", selection: $currentValue) {
                Text("Negative").tag(-1)
                Text("Neutral").tag(0)
                Text("Positive").tag(1)
            }
            .pickerStyle(.segmented)
        }
    }

    private func advance() {
        if index == questionBank.count - 1 {
            onFinish()
            return
        }
        index += 1
        currentValue = responses[q.id] ?? defaultValue(for: q.kind)
    }

    private func defaultValue(for kind: Question.Kind) -> Int {
        switch kind {
        case .yesNo: return 0
        case .scale0to3: return 0
        case .socialValence: return 0
        }
    }
}
