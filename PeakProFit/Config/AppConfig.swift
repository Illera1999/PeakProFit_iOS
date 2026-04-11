import Foundation

enum AppConfig {
    static var apiBaseURL: URL {
        guard
            let raw = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
            let url = URL(string: raw)
        else { fatalError("API_BASE_URL missing or invalid") }
        return url
    }

    static var rapidApiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "RAPID_API_KEY") as? String,
              !key.isEmpty else {
            fatalError("RAPID_API_KEY missing")
        }
        return key
    }
}
