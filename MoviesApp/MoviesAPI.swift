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
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            print("DEBUG: Secrets.plist not found in bundle!")
            return ""
        }
        
        guard let dict = NSDictionary(contentsOfFile: path) else {
            print("DEBUG: Could not read Secrets.plist")
            return ""
        }
        
        guard let key = dict["AIRTABLE_API_KEY"] as? String else {
            print("DEBUG: AIRTABLE_API_KEY not found in plist")
            return ""
        }
        
        print("DEBUG: API Key loaded successfully (length: \(key.count))")
        return key
    }
    
    static let baseURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies")!
    
    static func fetchMovies() async throws -> [Movie] {
        let key = apiKey
        
        if key.isEmpty {
            throw NSError(domain: "MoviesAPI", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "API key is missing. Check Secrets.plist file."
            ])
        }
        
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        
        print("DEBUG: Making request to: \(baseURL)")
        print("DEBUG: Authorization header: Bearer \(key.prefix(10))...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("DEBUG: Response status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                let responseString = String(data: data, encoding: .utf8) ?? "Unable to decode response"
                print("DEBUG: Error response: \(responseString)")
                throw NSError(domain: "MoviesAPI", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: "Server returned status \(httpResponse.statusCode): \(responseString)"
                ])
            }
        }
        
        let decoded = try JSONDecoder().decode(AirtableMoviesResponse.self, from: data)
        print("DEBUG: Successfully decoded \(decoded.records.count) movies")
        return decoded.records.map(Movie.init(from:))
    }
}
