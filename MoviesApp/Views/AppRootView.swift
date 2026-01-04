import SwiftUI

struct AppRootView: View {
    @State private var isSignedIn = false
    @State private var selectedMovie: Movie? = nil
    @State private var showingProfile = false
    @State private var showingAddReview = false

    var body: some View {
        NavigationStack {
            if !isSignedIn {
                // Use the SignInView from signin.swift
                SignInView(onSignIn: {
                    isSignedIn = true
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
                                ProfileView()
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
    }
}

#Preview {
    AppRootView()
}
