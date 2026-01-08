import SwiftUI

struct MoodView: View {
    @Binding var mood: Int
    var onNext: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Text("How is your mood right now?")
                .font(.title2)
                .multilineTextAlignment(.center)

            Text("\(mood)")
                .font(.system(size: 56, weight: .bold))
                .monospacedDigit()

            Slider(
                value: Binding(
                    get: { Double(mood) },
                    set: { mood = Int($0) }
                ),
                in: -10...10,
                step: 1
            )

            HStack(spacing: 12) {
                Button("Cancel") { onCancel() }
                    .buttonStyle(.bordered)

                Button("Next") { onNext() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
