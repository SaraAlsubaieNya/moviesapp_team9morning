import Foundation

struct AirtableUsersResponse: Codable {
    struct Record: Codable {
        let id: String
        let fields: Fields
    }
    struct Fields: Codable {
        let name: String?
        let password: String?
        let email: String?
        let profile_image: String?
    }
    let records: [Record]
}
