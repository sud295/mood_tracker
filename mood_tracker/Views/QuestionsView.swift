import SwiftUI

struct QuestionsView: View {
    @Binding var responses: [String: Int]
    var onFinish: () -> Void
    var onCancel: () -> Void

    @State private var index: Int = 0
    @State private var currentValue: Int = 0

    private var q: Question { QuestionBank.all[index] }

    var body: some View {
        VStack(spacing: 22) {
            Text("Question \(index + 1) of \(QuestionBank.all.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(q.text)
                .font(.title2)
                .multilineTextAlignment(.center)

            answerControl(for: q.kind)

            HStack(spacing: 12) {
                Button("Cancel") {
                    onCancel()
                }
                .buttonStyle(.bordered)

                Button(index == QuestionBank.all.count - 1 ? "Finish" : "Next") {
                    responses[q.id] = currentValue
                    advance()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .onAppear {
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
            scaleView(range: 0...3, label: "0 = none, 3 = a lot")

        case .scale0to5:
            scaleView(range: 0...5, label: "0 = not at all, 5 = extremely")
        }
    }

    private func scaleView(range: ClosedRange<Int>, label: String) -> some View {
        VStack(spacing: 12) {
            Text("\(currentValue)")
                .font(.system(size: 44, weight: .bold))
                .monospacedDigit()

            Slider(
                value: Binding(
                    get: { Double(currentValue) },
                    set: { currentValue = Int($0) }
                ),
                in: Double(range.lowerBound)...Double(range.upperBound),
                step: 1
            )

            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private func advance() {
        if index == QuestionBank.all.count - 1 {
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
        case .scale0to5: return 0
        }
    }
}
