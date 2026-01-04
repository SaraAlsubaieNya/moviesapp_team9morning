import SwiftUI

// MARK: - Color Constants
extension Color {
    static let moviesBackground = Color(hex: "#181818")
    static let moviesCard = Color(hex: "#232323")
    static let goldAccent = Color(hex: "#F4CB43")
}

// MARK: - Main View
struct moviescenter: View {
    @StateObject private var viewModel = MoviesViewModel()
    @ObservedObject var userSession = UserSession.shared
    @State private var searchText: String = ""
    @State private var currentTopPick = 0
    @State private var showingGenre: GenreSheet? = nil

    @Binding var selectedMovie: Movie?
    @Binding var showingProfile: Bool

    var filteredMovies: [Movie] {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return viewModel.movies }
        return viewModel.movies.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }

    var topPicks: [Movie] {
        filteredMovies.sorted { ($0.rating ?? 0) > ($1.rating ?? 0) }.prefix(5).map { $0 }
    }
    var dramaMovies: [Movie] {
        filteredMovies.filter { $0.genres.contains { $0.localizedCaseInsensitiveContains("Drama") } }
    }
    var comedyMovies: [Movie] {
        filteredMovies.filter { $0.genres.contains { $0.localizedCaseInsensitiveContains("Comedy") } }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {

                // MARK: - Header
                HStack {
                    Spacer()
                    Text("Movies Center")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        showingProfile = true
                    } label: {
                        ZStack {
                            if let imageURL = userSession.currentUser?.fields.profile_image,
                               let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Image("icon")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    }
                                }
                            } else {
                                Image("icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.goldAccent, lineWidth: 2))
                    }
                    .padding(.trailing, 8)
                }
                .padding(.top, 8)

                // MARK: - Search Bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for Movie name, actors ...", text: $searchText)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .disableAutocorrection(true)
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color.moviesCard)
                .cornerRadius(12)
                .padding(.horizontal, 20)

                // MARK: - Loading/Error State
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 10) {
                        Text("Error Loading Movies")
                            .foregroundColor(.red)
                            .font(.headline)
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.loadMovies() }
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                } else {
                    // MARK: - Top Picks (Full-width Carousel)
                    if !topPicks.isEmpty {
                        TopPicksCarousel(
                            movies: topPicks,
                            currentIndex: $currentTopPick,
                            onMovieSelect: { selectedMovie = $0 }
                        )
                        .padding(.top, 8)
                    }

                    // MARK: - Category Sections
                    if !dramaMovies.isEmpty {
                        MovieSection(
                            title: "Drama",
                            movies: Array(dramaMovies.prefix(3)),
                            allMovies: dramaMovies,
                            onShowMore: { showingGenre = GenreSheet(id: "Drama") },
                            onMovieSelect: { selectedMovie = $0 }
                        )
                    }
                    if !comedyMovies.isEmpty {
                        MovieSection(
                            title: "Comedy",
                            movies: Array(comedyMovies.prefix(3)),
                            allMovies: comedyMovies,
                            onShowMore: { showingGenre = GenreSheet(id: "Comedy") },
                            onMovieSelect: { selectedMovie = $0 }
                        )
                    }
                }

                Spacer(minLength: 24)
            }
            .background(Color.moviesBackground.ignoresSafeArea())
        }
        .background(Color.moviesBackground.ignoresSafeArea())
        .sheet(item: $showingGenre) { genre in
            if genre.id == "Drama" {
                GenreFullListView(
                    genre: "Drama",
                    movies: dramaMovies,
                    onMovieSelect: { selectedMovie = $0 }
                )
            } else if genre.id == "Comedy" {
                GenreFullListView(
                    genre: "Comedy",
                    movies: comedyMovies,
                    onMovieSelect: { selectedMovie = $0 }
                )
            }
        }
        .task { await viewModel.loadMovies() }
    }
}

// MARK: - Top Picks Carousel
struct TopPicksCarousel: View {
    let movies: [Movie]
    @Binding var currentIndex: Int
    var onMovieSelect: (Movie) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Top Picks")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 20)

            TabView(selection: $currentIndex) {
                ForEach(Array(movies.enumerated()), id: \.element.id) { idx, movie in
                    Button {
                        onMovieSelect(movie)
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            Group {
                                if let url = movie.imageURL {
                                    AsyncImage(url: url) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } else if phase.error != nil {
                                            Color.gray.opacity(0.2)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .font(.title)
                                                        .foregroundStyle(.secondary)
                                                )
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                } else {
                                    Color.gray.opacity(0.2)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.title)
                                                .foregroundStyle(.secondary)
                                        )
                                }
                            }
                            
                            // Gradient overlay
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, .black.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 120)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            
                            // Movie info overlay
                            VStack(alignment: .leading, spacing: 6) {
                                Text(movie.title)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                
                                if let rating = movie.rating {
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.goldAccent)
                                            .font(.system(size: 14))
                                        Text(String(format: "%.1f", rating))
                                            .foregroundColor(.goldAccent)
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                }
                                
                                if let genre = movie.genreText {
                                    Text(genre)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.85))
                                        .lineLimit(1)
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 270)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(radius: 12, y: 6)
                        .padding(.horizontal, 20)
                    }
                    .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 290)
        }
    }
}

// MARK: - Movie Section (Horizontal List)
struct MovieSection: View {
    let title: String
    let movies: [Movie]
    let allMovies: [Movie]
    let onShowMore: () -> Void
    let onMovieSelect: (Movie) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Button(action: onShowMore) {
                    Text("Show more")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.goldAccent)
                }
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies) { movie in
                        Button(action: { onMovieSelect(movie) }) {
                            MovieCardView(movie: movie)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Movie Card (Reusable)
struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let url = movie.imageURL {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        Color.gray.opacity(0.2)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            )
                    } else {
                        ProgressView()
                    }
                }
            } else {
                Color.gray.opacity(0.2)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    )
            }
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, .black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 70)
            .frame(maxHeight: .infinity, alignment: .bottom)
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .shadow(radius: 2)
                if let genre = movie.genreText {
                    Text(genre)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                        .shadow(radius: 1)
                        .lineLimit(1)
                }
            }
            .padding(10)
        }
        .frame(width: 155, height: 210)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(radius: 8, y: 4)
    }
}

// MARK: - Genre Sheet (Grid)
struct GenreSheet: Identifiable, Equatable {
    let id: String
}

struct GenreFullListView: View, Identifiable {
    let id = UUID()
    let genre: String
    let movies: [Movie]
    let onMovieSelect: (Movie) -> Void

    @Environment(\.dismiss) private var dismiss

    let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.moviesBackground.ignoresSafeArea()

                ScrollView(showsIndicators: true) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(movies) { movie in
                            Button(action: {
                                onMovieSelect(movie)
                                dismiss()
                            }) {
                                MovieCardView(movie: movie)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(genre)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.goldAccent)
                }
            }
            .toolbarBackground(Color.moviesBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: - Color Hex Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue:  Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Preview
struct moviescenter_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedMovie: Movie? = nil
        @State var showingProfile: Bool = false

        var body: some View {
            moviescenter(selectedMovie: $selectedMovie, showingProfile: $showingProfile)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .preferredColorScheme(.dark)
    }
}
