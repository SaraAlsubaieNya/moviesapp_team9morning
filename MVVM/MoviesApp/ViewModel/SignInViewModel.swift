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

    // Simulated sign-in; replace with your authentication logic
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
                let inputEmail = trimmedEmail.lowercased()
                let inputPassword = trimmedPassword

                if users.first(where: {
                    let recordEmail = $0.fields.email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    let recordPassword = $0.fields.password ?? ""
                    return recordEmail == inputEmail && recordPassword == inputPassword
                }) != nil {
                    // Successful login
                    completion(true)
                } else {
                    self.errorMessage = "Invalid email or password."
                    completion(false)
                }
            } catch {
                self.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }
}
