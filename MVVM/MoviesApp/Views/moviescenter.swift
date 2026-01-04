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
        ZStack {
            Color.moviesBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Header
                    HStack(spacing: 0) {
                        Spacer()
                        Text("Movies Center")
                            .font(.system(size: 24, weight: .bold))
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
                                            Circle()
                                                .fill(Color.gray.opacity(0.3))
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.goldAccent, lineWidth: 2))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    // MARK: - Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                        TextField("Search for Movie name, actors ...", text: $searchText)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .background(Color.moviesCard)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)

                    // MARK: - Loading/Error State
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .tint(.white)
                            Text("Loading movies...")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40))
                                .foregroundColor(.red.opacity(0.8))
                            Text("Error Loading Movies")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                            Text(error)
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            Button {
                                Task { await viewModel.loadMovies() }
                            } label: {
                                Text("Retry")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.moviesBackground)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 12)
                                    .background(Color.goldAccent)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        // MARK: - Top Picks Carousel
                        if !topPicks.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("High Rated")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                
                                TabView(selection: $currentTopPick) {
                                    ForEach(Array(topPicks.enumerated()), id: \.element.id) { idx, movie in
                                        Button {
                                            selectedMovie = movie
                                        } label: {
                                            TopPickCard(movie: movie)
                                        }
                                        .tag(idx)
                                    }
                                }
                                .tabViewStyle(.page(indexDisplayMode: .always))
                                .indexViewStyle(.page(backgroundDisplayMode: .always))
                                .frame(height: 280)
                            }
                        }

                        // MARK: - Drama Section
                        if !dramaMovies.isEmpty {
                            MovieSection(
                                title: "Drama",
                                movies: Array(dramaMovies.prefix(10)),
                                onShowMore: { showingGenre = GenreSheet(id: "Drama") },
                                onMovieSelect: { selectedMovie = $0 }
                            )
                        }
                        
                        // MARK: - Comedy Section
                        if !comedyMovies.isEmpty {
                            MovieSection(
                                title: "Comedy",
                                movies: Array(comedyMovies.prefix(10)),
                                onShowMore: { showingGenre = GenreSheet(id: "Comedy") },
                                onMovieSelect: { selectedMovie = $0 }
                            )
                        }
                    }

                    Spacer(minLength: 24)
                }
            }
        }
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

// MARK: - Top Pick Card
struct TopPickCard: View {
    let movie: Movie
    
    var body: some View {
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
                                        .font(.system(size: 40))
                                        .foregroundStyle(.gray)
                                )
                        } else {
                            Color.moviesCard
                                .overlay(
                                    ProgressView()
                                        .tint(.white)
                                )
                        }
                    }
                } else {
                    Color.gray.opacity(0.2)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundStyle(.gray)
                        )
                }
            }
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.85)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 140)
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            // Movie info
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
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
                        Text("• \(genre)")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    if let duration = movie.duration {
                        Text("• \(duration)")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
        .padding(.horizontal, 20)
    }
}

// MARK: - Movie Section (Horizontal Scroll)
struct MovieSection: View {
    let title: String
    let movies: [Movie]
    let onShowMore: () -> Void
    let onMovieSelect: (Movie) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
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
                HStack(spacing: 12) {
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

// MARK: - Movie Card
struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        ZStack(alignment: .bottomLeading) {
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
                                    .font(.system(size: 24))
                                    .foregroundStyle(.gray)
                            )
                    } else {
                        Color.moviesCard
                            .overlay(
                                ProgressView()
                                    .tint(.white)
                            )
                    }
                }
            } else {
                Color.gray.opacity(0.2)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundStyle(.gray)
                    )
            }
            
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.85)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 60)
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let genre = movie.genreText {
                    Text(genre)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.75))
                        .lineLimit(1)
                }
            }
            .padding(10)
        }
        .frame(width: 140, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
    }
}

// MARK: - Genre Sheet
struct GenreSheet: Identifiable, Equatable {
    let id: String
}

struct GenreFullListView: View {
    let genre: String
    let movies: [Movie]
    let onMovieSelect: (Movie) -> Void

    @Environment(\.dismiss) private var dismiss

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.moviesBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(movies) { movie in
                            Button(action: {
                                onMovieSelect(movie)
                                dismiss()
                            }) {
                                MovieCardView(movie: movie)
                                    .frame(width: 165, height: 230)
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
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
