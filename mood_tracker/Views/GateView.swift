import SwiftUI
import Combine

struct GateView: View {
    @ObservedObject var gateManager: GateManager
    var onStart: () -> Void

    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            Text("mood_tracker")
                .font(.largeTitle)
                .bold()

            if gateManager.canStartMeasurement(now: now) {
                Text("You can log a new measurement.")
                    .font(.headline)

                Button("Start Measurement") {
                    onStart()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("You can log again in:")
                    .font(.headline)

                Text(formatSeconds(gateManager.remainingSeconds(now: now)))
                    .font(.system(size: 40, weight: .bold))
                    .monospacedDigit()

                Button("Start Measurement") { }
                    .buttonStyle(.borderedProminent)
                    .disabled(true)
            }

            // Optional debug button:
            // Button("Reset Gate (Debug)") { gateManager.resetGate() }
            //     .font(.footnote)
            //     .foregroundStyle(.secondary)
        }
        .padding()
        .onAppear { gateManager.refresh() }
        .onReceive(timer) { now = $0 }
    }

    private func formatSeconds(_ s: Int) -> String {
        let m = s / 60
        let r = s % 60
        return "\(m)m \(String(format: "%02d", r))s"
    }
}
