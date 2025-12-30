import Foundation

struct AirtableMoviesResponse: Codable {
    struct Record: Codable {
        let id: String
        let fields: Fields
    }
    struct Fields: Codable {
        let name: String?
        let poster: String?
        let genre: [String]?
        let IMDb_rating: Double?
        let runtime: String?
    }
    let records: [Record]
}

struct Movie: Identifiable, Hashable {
    let id: String
    let title: String
    let imageURL: URL?
    let genres: [String]
    let rating: Double?
    let duration: String?
    
    init(from record: AirtableMoviesResponse.Record) {
        self.id = record.id
        self.title = record.fields.name ?? "Untitled"
        self.imageURL = URL(string: record.fields.poster ?? "")
        self.genres = record.fields.genre ?? []
        self.rating = record.fields.IMDb_rating
        self.duration = record.fields.runtime
    }
    
    var genreText: String? {
        genres.first
    }
}

enum MoviesAPI {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["AIRTABLE_API_KEY"] as? String else {
            return ""
        }
        return key
    }
    
    static let baseURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies")!
    
    static func fetchMovies() async throws -> [Movie] {
        var request = URLRequest(url: baseURL)
        // Fix: Add "Bearer " prefix to the API key
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(AirtableMoviesResponse.self, from: data)
        return decoded.records.map(Movie.init(from:))
    }
}
