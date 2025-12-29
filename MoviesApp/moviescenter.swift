import SwiftUI


struct GenreSheet: Identifiable, Equatable {
    let id: String
}

struct moviescenter: View {
    @State private var movies: [Movie] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var searchText: String = ""
    
    
    @State private var showingGenre: GenreSheet? = nil
    
    var filteredMovies: [Movie] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return movies }
        return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    
                   
                    HStack {
                        Spacer()
                        Text("Movies Center")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.trailing, 20)
                    }
                    
                    // Search bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for Movie name , actors ...", text: $searchText)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .regular))
                            .disableAutocorrection(true)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color(hex: "#232323"))
                    .cornerRadius(12)
                    .padding(.top, 0)
                    .padding(.horizontal, 20)
                    
                    if isLoading {
                        ProgressView().padding()
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // High Rated Section
                        if let highRated = highRatedMovie {
                            HighRatedSection(movie: highRated)
                                .padding(.top, 0)
                        }
                        
                        // Drama Section
                        if !dramaMovies.isEmpty {
                            SectionView(
                                section: "Drama",
                                movies: Array(dramaMovies.prefix(3)),
                                allMovies: dramaMovies,
                                onShowMore: { showingGenre = GenreSheet(id: "Drama") }
                            )
                        }
                        // Comedy Section
                        if !comedyMovies.isEmpty {
                            SectionView(
                                section: "Comedy",
                                movies: Array(comedyMovies.prefix(3)),
                                allMovies: comedyMovies,
                                onShowMore: { showingGenre = GenreSheet(id: "Comedy") }
                            )
                        }
                    }
                    
                    Spacer(minLength: 16)
                }
                .background(Color(hex: "#181818").ignoresSafeArea())
            }
            .background(Color(hex: "#181818").ignoresSafeArea())
            .sheet(item: $showingGenre) { genre in
                if genre.id == "Drama" {
                    GenreFullListView(
                        genre: "Drama",
                        movies: dramaMovies
                    )
                } else if genre.id == "Comedy" {
                    GenreFullListView(
                        genre: "Comedy",
                        movies: comedyMovies
                    )
                }
            }
        }
        .task {
            await loadMovies()
        }
    }
    
    // MARK: - Movie Filtering
    var highRatedMovie: Movie? {
        filteredMovies.max { ($0.rating ?? 0) < ($1.rating ?? 0) }
    }
    
    var dramaMovies: [Movie] {
        filteredMovies.filter { $0.genres.contains(where: { $0.localizedCaseInsensitiveContains("Drama") }) }
    }
    
    var comedyMovies: [Movie] {
        filteredMovies.filter { $0.genres.contains(where: { $0.localizedCaseInsensitiveContains("Comedy") }) }
    }
    
    func loadMovies() async {
        do {
            isLoading = true
            errorMessage = nil
            movies = try await MoviesAPI.fetchMovies()
            isLoading = false
        } catch {
            errorMessage = "Failed to load movies."
            isLoading = false
        }
    }
}

// MARK: - SectionView: Horizontal Scroll, 3 movies, Show More
struct SectionView: View {
    let section: String
    let movies: [Movie]
    let allMovies: [Movie]
    let onShowMore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(section)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Button(action: onShowMore) {
                    Text("Show more")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#F4CB43"))
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(movies) { movie in
                        VStack(alignment: .leading, spacing: 8) {
                            if let url = movie.imageURL {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(2/3, contentMode: .fill)
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
                                .frame(width: 155, height: 210)
                                .cornerRadius(8)
                                .clipped()
                            } else {
                                Color.gray.opacity(0.2)
                                    .frame(width: 155, height: 210)
                                    .cornerRadius(8)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.title2)
                                            .foregroundStyle(.secondary)
                                    )
                            }
                            Text(movie.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 155)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - GenreFullListView: Modal for all movies of one genre
struct GenreFullListView: View, Identifiable {
    let id = UUID()
    let genre: String
    let movies: [Movie]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 14) {
                    ForEach(movies) { movie in
                        VStack(alignment: .leading, spacing: 8) {
                            if let url = movie.imageURL {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(2/3, contentMode: .fill)
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
                                .frame(width: 170, height: 230)
                                .cornerRadius(10)
                                .clipped()
                            } else {
                                Color.gray.opacity(0.2)
                                    .frame(width: 170, height: 230)
                                    .cornerRadius(10)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.title2)
                                            .foregroundStyle(.secondary)
                                    )
                            }
                            Text(movie.title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 170)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Color(hex: "#181818").ignoresSafeArea())
            .navigationTitle(genre)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: { dismiss() })
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}


struct HighRatedSection: View {
    let movie: Movie
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("High Rated")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            ZStack(alignment: .bottomLeading) {
                if let url = movie.imageURL {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(16/9, contentMode: .fill)
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
                    .frame(height: 220)
                    .clipped()
                } else {
                    Color.gray.opacity(0.2)
                        .frame(height: 220)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        )
                }
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.05), Color.black.opacity(0.90)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    HStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(hex: "#F4CB43"))
                            .font(.system(size: 14))
                        Text(String(format: "%.1f", movie.rating ?? 0))
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                        Text("out of 5")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    if let genre = movie.genreText, let duration = movie.duration {
                        Text("\(genre), \(duration)")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    } else if let genre = movie.genreText {
                        Text(genre)
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    } else if let duration = movie.duration {
                        Text(duration)
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                }
                .padding(18)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            HStack(spacing: 6) {
                ForEach(0..<5) { idx in
                    Circle()
                        .fill(idx == 0 ? Color.white : Color.white.opacity(0.2))
                        .frame(width: 7, height: 7)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, -10)
        }
    }
}


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

#Preview {
    moviescenter()
}
