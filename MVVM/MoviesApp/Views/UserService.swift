import Foundation

class UserService {
    static let shared = UserService()
    
    private let baseURL: String
    private let token: String
    
    private init() {
        // Read from Secrets.plist
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let secrets = NSDictionary(contentsOfFile: path),
              let apiToken = secrets["AIRTABLE_API_KEY"] as? String else {
            fatalError("Secrets.plist not found or missing required keys")
        }
        
        // Base ID hardcoded since it's not in Secrets.plist
        let baseID = "appsfcB6YESLj4NCN"
        
        self.baseURL = "https://api.airtable.com/v0/\(baseID)/users"
        self.token = "Bearer \(apiToken)"
    }
    
    // GET /users - retrieve all users
    func fetchUsers() async throws -> [AirtableUsersResponse.Record] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("Status Code: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("Error Response: \(errorString)")
            }
            throw URLError(.badServerResponse)
        }
        
        let apiResponse = try JSONDecoder().decode(AirtableUsersResponse.self, from: data)
        return apiResponse.records
    }
    
    // PATCH /users/:id - update user data
    func updateUser(
        recordId: String,
        name: String?,
        email: String?,
        profileImage: String?,
        password: String? = nil
    ) async throws {
        guard let url = URL(string: "\(baseURL)/\(recordId)") else {
            throw URLError(.badURL)
        }
        
        // Build the fields object - only include non-nil values
        var fields: [String: Any] = [:]
        if let name = name { fields["name"] = name }
        if let email = email { fields["email"] = email }
        if let profileImage = profileImage { fields["profile_image"] = profileImage }
        if let password = password { fields["password"] = password }
        
        // Create request body with fields wrapped (Airtable format)
        let body: [String: Any] = ["fields": fields]
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"  // Airtable uses PATCH for updates
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("Update Status Code: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("Update Error Response: \(errorString)")
            }
            throw URLError(.badServerResponse)
        }
    }
}
