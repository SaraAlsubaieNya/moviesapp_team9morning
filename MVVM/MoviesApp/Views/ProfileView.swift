import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @ObservedObject var userSession = UserSession.shared
    @Binding var selectedMovie: Movie?
    @State private var showingEditProfile = false

    private let gridSpacing: CGFloat = 12
    private let cornerRadius: CGFloat = 10
    private let horizontalPadding: CGFloat = 16
    private let columnsCount: Int = 2
    private let fixedItemWidth: CGFloat = 172
    private let fixedItemHeight: CGFloat = 237

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Profile")
                    .font(.largeTitle.bold())
                    .padding(.top, 8)
                    .padding(.horizontal, horizontalPadding)

                // User Profile Card - Tappable
                Button {
                    showingEditProfile = true
                } label: {
                    HStack(spacing: 12) {
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
                                            .font(.system(size: 22, weight: .semibold))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color(.systemGray4))
                                Image(systemName: "person.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(width: 48, height: 48)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(userSession.currentUser?.fields.name ?? "User")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(userSession.currentUser?.fields.email ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer(minLength: 0)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, horizontalPadding)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Saved movies")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, horizontalPadding)

                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.horizontal, horizontalPadding)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding(.horizontal, horizontalPadding)
                    } else {
                        let columns = Array(
                            repeating: GridItem(.fixed(fixedItemWidth), spacing: gridSpacing, alignment: .top),
                            count: columnsCount
                        )

                        LazyVGrid(columns: columns, alignment: .leading, spacing: gridSpacing) {
                            let savedMovies = viewModel.movies.filter {
                                userSession.savedMovieIDs.contains($0.id)
                            }

                            if savedMovies.isEmpty {
                                Text("No saved movies yet")
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, horizontalPadding)
                            } else {
                                ForEach(savedMovies) { movie in
                                    Button {
                                        selectedMovie = movie
                                    } label: {
                                        AsyncImage(url: movie.imageURL) { phase in
                                            if let image = phase.image {
                                                image.resizable().scaledToFill()
                                            } else {
                                                Color.gray.opacity(0.2)
                                            }
                                        }
                                        .frame(width: fixedItemWidth, height: fixedItemHeight)
                                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .task {
            await viewModel.loadMovies()
        }
    }
}

#Preview {
    ProfileView(selectedMovie: .constant(nil))
}

