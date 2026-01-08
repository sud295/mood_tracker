import SwiftUI
import SwiftData

@main
struct mood_trackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Measurement.self])
    }
}
