import SwiftUI
import SwiftData
import Charts

struct MoodChartView: View {
    @Query private var measurements: [Measurement]

    init() {
        let since = Date().addingTimeInterval(-24 * 60 * 60)
        _measurements = Query(
            filter: #Predicate<Measurement> { $0.createdAt >= since },
            sort: [SortDescriptor(\.createdAt, order: .forward)]
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 24 hours")
                .font(.headline)

            if measurements.isEmpty {
                Text("No measurements yet.")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 12)
            } else {
                Chart {
                    ForEach(measurements, id: \.id) { m in
                        LineMark(
                            x: .value("Time", m.createdAt),
                            y: .value("Mood", m.mood)
                        )
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Time", m.createdAt),
                            y: .value("Mood", m.mood)
                        )
                    }
                }
                .chartYScale(domain: -10...10)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.hour().minute())
                    }
                }
                .frame(height: 220)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
    }
}
