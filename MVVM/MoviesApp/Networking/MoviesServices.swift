
import Foundation

final class MoviesService {
    static let shared = MoviesService()
    private init() {}

    private let baseURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies")!

    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["AIRTABLE_API_KEY"] as? String else {
            print("DEBUG: Could not find AIRTABLE_API_KEY in Secrets.plist")
            return ""
        }
        return key
    }

    func fetchMovies() async throws -> [Movie] {
        let key = apiKey
        guard !key.isEmpty else {
            throw NSError(domain: "MoviesService", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "API key is missing. Check Secrets.plist file."
            ])
        }

        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let responseString = String(data: data, encoding: .utf8) ?? "Unable to decode response"
            throw NSError(domain: "MoviesService", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "Server returned status \(httpResponse.statusCode): \(responseString)"
            ])
        }

        let decoded = try JSONDecoder().decode(AirtableMoviesResponse.self, from: data)
        return decoded.records.map(Movie.init(from:))
    }
}
