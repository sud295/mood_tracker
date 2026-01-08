import Foundation

struct RemoteClient {
    let baseURL = URL(string: "https://mood-endpoint.siddharth-shastry26.workers.dev")!
    let apiKey: String  // pass in

    func postEvent(_ event: [String: Any]) async throws {
        let url = baseURL.appendingPathComponent("/v1/events")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        req.httpBody = try JSONSerialization.data(withJSONObject: event)

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "RemoteClient", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode): \(body)"])
        }
    }
}
