import SwiftUI
import Combine

struct GateView: View {
    @ObservedObject var gateManager: GateManager
    var onStart: () -> Void

    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Mood Tracker")
                    .font(.largeTitle)
                    .bold()

                gateCard

                // Chart section
                MoodChartView()

                Spacer(minLength: 24)
            }
            .padding()
        }
        .onAppear { gateManager.refresh() }
        .onReceive(timer) { now = $0 }
    }

    @ViewBuilder
    private var gateCard: some View {
        VStack(spacing: 14) {
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
        }
        .frame(maxWidth: .infinity)
        .padding()
//        .background(.ultraThinMaterial)
//        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func formatSeconds(_ s: Int) -> String {
        let m = s / 60
        let r = s % 60
        return "\(m)m \(String(format: "%02d", r))s"
    }
}
