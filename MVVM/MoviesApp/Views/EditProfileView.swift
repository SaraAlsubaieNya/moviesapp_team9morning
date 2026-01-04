import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var userSession = UserSession.shared
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var profileImageURL: String = ""
    @State private var isSaving: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showingSuccess: Bool = false
    
    private let horizontalPadding: CGFloat = 16
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Profile Image Section
                    VStack(spacing: 16) {
                        ZStack {
                            if let imageURL = userSession.currentUser?.fields.profile_image,
                               let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Circle()
                                            .fill(Color(.systemGray4))
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40, weight: .semibold))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 100, height: 100)
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Text("Edit profile")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                    .padding(.top, 8)
                    
                    // Form Fields
                    VStack(alignment: .leading, spacing: 20) {
                        // First Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First name")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            
                            TextField("", text: $firstName)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color(.secondarySystemBackground))
                                )
                        }
                        
                        // Last Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Last name")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            
                            TextField("", text: $lastName)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color(.secondarySystemBackground))
                                )
                        }
                    }
                    
                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }
                    
                    // Success Message
                    if showingSuccess {
                        Text("Profile updated successfully!")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                    
                    // Sign Out Button
                    Button {
                        UserSession.shared.logout()
                    } label: {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 24)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Profile Info")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(isSaving)
                }
            }
        }
        .onAppear {
            loadCurrentUserData()
        }
    }
    
    private func loadCurrentUserData() {
        guard let user = userSession.currentUser else { return }
        
        // Split the name into first and last name
        let nameParts = (user.fields.name ?? "").split(separator: " ")
        firstName = String(nameParts.first ?? "")
        lastName = nameParts.count > 1 ? nameParts.dropFirst().joined(separator: " ") : ""
        
        profileImageURL = user.fields.profile_image ?? ""
    }
    
    private func saveProfile() {
        errorMessage = nil
        showingSuccess = false
        isSaving = true
        
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        Task {
            defer { isSaving = false }
            do {
                try await userSession.updateUser(
                    name: fullName,
                    email: nil, // Keep email unchanged
                    profileImage: profileImageURL.isEmpty ? nil : profileImageURL
                )
                showingSuccess = true
                
                // Dismiss after a short delay
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                dismiss()
            } catch {
                errorMessage = "Failed to update profile: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    EditProfileView()
}
