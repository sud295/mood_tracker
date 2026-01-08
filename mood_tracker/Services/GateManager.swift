import Foundation
import Combine

@MainActor
final class GateManager: ObservableObject {
    private let key = "lastCompletedMeasurementAt"
    private let interval: TimeInterval = 3600 // 1 hour

    @Published private(set) var nextAllowedAt: Date? = nil

    init() {
        refresh()
    }

    func refresh() {
        if let last = UserDefaults.standard.object(forKey: key) as? Date {
            nextAllowedAt = last.addingTimeInterval(interval)
        } else {
            nextAllowedAt = nil
        }
    }

    func canStartMeasurement(now: Date = Date()) -> Bool {
        guard let next = nextAllowedAt else { return true }
        return now >= next
    }

    func remainingSeconds(now: Date = Date()) -> Int {
        guard let next = nextAllowedAt else { return 0 }
        return max(0, Int(next.timeIntervalSince(now)))
    }

    func markCompleted(at date: Date = Date()) {
        UserDefaults.standard.set(date, forKey: key)
        nextAllowedAt = date.addingTimeInterval(interval)
    }

    // Helpful for debugging
    func resetGate() {
        UserDefaults.standard.removeObject(forKey: key)
        nextAllowedAt = nil
    }
}
