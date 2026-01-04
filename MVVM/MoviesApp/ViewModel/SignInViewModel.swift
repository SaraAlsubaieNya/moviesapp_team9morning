import Foundation
import SwiftUI
import Combine

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

    @Published var isSigningIn: Bool = false
    @Published var errorMessage: String? = nil

    func signIn(completion: @escaping (Bool) -> Void) {
        errorMessage = nil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password
        
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "Email and password required."
            completion(false)
            return
        }

        isSigningIn = true
        Task {
            defer { self.isSigningIn = false }
            do {
                let users = try await UserService.shared.fetchUsers()
                print("Fetched \(users.count) users from API")
                
                let inputEmail = trimmedEmail.lowercased()
                let inputPassword = trimmedPassword
                
                print("Looking for email: \(inputEmail)")
                
                // Debug: Print all users
                for user in users {
                    let userEmail = user.fields.email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? "NO EMAIL"
                    let userPassword = user.fields.password ?? "NO PASSWORD"
                    print("User: \(userEmail) | Password: \(userPassword)")
                }
                
                if let user = users.first(where: {
                    let recordEmail = $0.fields.email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    let recordPassword = $0.fields.password ?? ""
                    
                    let emailMatch = recordEmail == inputEmail
                    let passwordMatch = recordPassword == inputPassword
                    
                    print("Checking: \(recordEmail ?? "nil") == \(inputEmail) : \(emailMatch)")
                    print("Password match: \(passwordMatch)")
                    
                    return emailMatch && passwordMatch
                }) {
                    print("Login successful for: \(user.fields.email ?? "")")
                    // Save user to session
                    UserSession.shared.login(user: user)
                    completion(true)
                } else {
                    print("No matching user found")
                    self.errorMessage = "Invalid email or password."
                    completion(false)
                }
            } catch {
                print("Sign in error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }
}
