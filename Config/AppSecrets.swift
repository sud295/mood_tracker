import Foundation

enum AppSecrets {
    static let ingestApiKey: String = {
        guard
            let url = Bundle.main.url(forResource: "secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [String: Any],
            let key = dict["INGEST_API_KEY"] as? String,
            !key.isEmpty
        else {
            fatalError("❌ INGEST_API_KEY missing from secrets.plist")
        }

        return key
    }()
}
