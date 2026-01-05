import Foundation
import SwiftUI
import Combine 

@MainActor
class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var currentUser: AirtableUsersResponse.Record?
    @Published var isLoggedIn: Bool = false
    @Published var savedMovieIDs: Set<String> = [] {
        didSet {
            UserDefaults.standard.set(Array(savedMovieIDs), forKey: "savedMovieIDs")
        }
    }
    
    private init() {
        if let saved = UserDefaults.standard.array(forKey: "savedMovieIDs") as? [String] {
            self.savedMovieIDs = Set(saved)
        }
    }
        
    func isMovieSaved(_ movie: Movie) -> Bool {
        savedMovieIDs.contains(movie.id)
    }

    func toggleSave(movie: Movie) {
        if savedMovieIDs.contains(movie.id) {
            savedMovieIDs.remove(movie.id)
        } else {
            savedMovieIDs.insert(movie.id)
        }
    }
    
    func login(user: AirtableUsersResponse.Record) {
        self.currentUser = user
        self.isLoggedIn = true
        UserDefaults.standard.set(user.id, forKey: "loggedInUserId")
    }
    
    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "loggedInUserId")
    }
    
    func updateUser(name: String?, email: String?, profileImage: String?) async throws {
        guard let currentUser = currentUser else { return }
        
        try await UserService.shared.updateUser(
            recordId: currentUser.id,
            name: name,
            email: email,
            profileImage: profileImage
        )
        
        let users = try await UserService.shared.fetchUsers()
        if let updatedUser = users.first(where: { $0.id == currentUser.id }) {
            self.currentUser = updatedUser
        }
    }
    
    func updatePassword(newPassword: String) async throws {
        guard let currentUser = currentUser else { return }
        
        try await UserService.shared.updateUser(
            recordId: currentUser.id,
            name: nil,
            email: nil,
            profileImage: nil,
            password: newPassword
        )
    }
    
    func restoreSession() async {
        guard let userId = UserDefaults.standard.string(forKey: "loggedInUserId") else { return }
        
        do {
            let users = try await UserService.shared.fetchUsers()
            if let user = users.first(where: { $0.id == userId }) {
                self.currentUser = user
                self.isLoggedIn = true
            }
        } catch {
            print("Failed to restore session: \(error)")
        }
    }
}
