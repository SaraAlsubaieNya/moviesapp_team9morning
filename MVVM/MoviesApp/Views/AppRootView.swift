import SwiftUI

struct AppRootView: View {
    @StateObject private var userSession = UserSession.shared
    @State private var selectedMovie: Movie? = nil
    @State private var showingProfile = false
    @State private var showingAddReview = false

    var body: some View {
        NavigationStack {
            if !userSession.isLoggedIn {
                SignInView(onSignIn: {
                    // The sign in is handled by UserSession now
                })
                .navigationBarBackButtonHidden(true)
            } else {
                ZStack {
                    // Main navigation
                    moviescenter(selectedMovie: $selectedMovie, showingProfile: $showingProfile)
                        .navigationDestination(isPresented: Binding(get: {
                            selectedMovie != nil
                        }, set: { newVal in
                            if !newVal { selectedMovie = nil }
                        })) {
                            if let movie = selectedMovie {
                                moviedetails(movie: movie, showingAddReview: $showingAddReview)
                            }
                        }
                        .sheet(isPresented: $showingProfile) {
                            NavigationStack {
                                ProfileView(selectedMovie: $selectedMovie)
                                    .toolbar {
                                        ToolbarItem(placement: .cancellationAction) {
                                            Button("Close") { showingProfile = false }
                                        }
                                    }
                            }
                        }
                        .sheet(isPresented: $showingAddReview) {
                            NavigationStack {
                                AddReviewView()
                                    .toolbar {
                                        ToolbarItem(placement: .cancellationAction) {
                                            Button("Close") { showingAddReview = false }
                                        }
                                    }
                            }
                        }
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .task {
            // Try to restore previous session on app launch
            await userSession.restoreSession()
        }
    }
}

#Preview {
    AppRootView()
}
