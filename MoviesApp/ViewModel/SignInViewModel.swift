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
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password required."
            completion(false)
            return
        }

        isSigningIn = true
        Task {
            defer { self.isSigningIn = false }
            do {
                let users = try await UserService.shared.fetchUsers()
                if users.first(where: {
                    ($0.fields.email?.caseInsensitiveCompare(self.email) == .orderedSame) &&
                    ($0.fields.password ?? "") == self.password
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
