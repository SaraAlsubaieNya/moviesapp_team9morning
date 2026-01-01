import SwiftUI

struct GenreSheet: Identifiable, Equatable {
    let id: String
}

struct moviescenter: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var searchText: String = ""
    @State private var currentHighRatedIndex = 0
    @State private var showingGenre: GenreSheet? = nil
    
    //New navigation states
    @Binding var selectedMovie: Movie?
    @Binding var showingProfile: Bool

    var filteredMovies: [Movie] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return viewModel.movies }
        return viewModel.movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                
                HStack(spacing: 12) {
                    Spacer()
                    Text("Movies Center")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Button {
                        showingProfile = true
                    } label: {
                        Image("icon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Profile")
                }
                .padding(.top, 10)
                .padding(.trailing, 20)
                
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
                
                if viewModel.isLoading {
                    ProgressView().padding()
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 10) {
                        Text("Error Loading Movies")
                            .foregroundColor(.red)
                            .font(.headline)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.loadMovies()
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                } else {
                    if !highRatedMovies.isEmpty {
                        HighRatedSection(
                            movies: highRatedMovies,
                            currentIndex: $currentHighRatedIndex
                        )
                        .padding(.top, 0)
                        .onTapGesture {
                            // Optionally no-op: slider is not per-movie.
                        }
                    }
                    
                    if !dramaMovies.isEmpty {
                        SectionView(
                            section: "Drama",
                            movies: Array(dramaMovies.prefix(3)),
                            allMovies: dramaMovies,
                            onShowMore: { showingGenre = GenreSheet(id: "Drama") },
                            onMovieSelect: { movie in selectedMovie = movie }
                        )
                    }
                    if !comedyMovies.isEmpty {
                        SectionView(
                            section: "Comedy",
                            movies: Array(comedyMovies.prefix(3)),
                            allMovies: comedyMovies,
                            onShowMore: { showingGenre = GenreSheet(id: "Comedy") },
                            onMovieSelect: { movie in selectedMovie = movie }
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
                    movies: dramaMovies,
                    onMovieSelect: { movie in selectedMovie = movie }
                )
            } else if genre.id == "Comedy" {
                GenreFullListView(
                    genre: "Comedy",
                    movies: comedyMovies,
                    onMovieSelect: { movie in selectedMovie = movie }
                )
            }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
    
    var highRatedMovies: [Movie] {
        filteredMovies.sorted { ($0.rating ?? 0) > ($1.rating ?? 0) }.prefix(5).map { $0 }
    }
    
    var dramaMovies: [Movie] {
        filteredMovies.filter { $0.genres.contains(where: { $0.localizedCaseInsensitiveContains("Drama") }) }
    }
    
    var comedyMovies: [Movie] {
        filteredMovies.filter { $0.genres.contains(where: { $0.localizedCaseInsensitiveContains("Comedy") }) }
    }
}

//Update SectionView to accept movie tap closure
struct SectionView: View {
    let section: String
    let movies: [Movie]
    let allMovies: [Movie]
    let onShowMore: () -> Void
    let onMovieSelect: (Movie) -> Void
    
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
                                .lineLimit(1)
                                .frame(width: 155)
                        }
                        .frame(width: 155)
                        .onTapGesture { onMovieSelect(movie) }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

//Update GenreFullListView for movie selection
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
                Color(hex: "#181818")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: true) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(movies) { movie in
                            VStack(alignment: .leading, spacing: 8) {
                                if let url = movie.imageURL {
                                    AsyncImage(url: url) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 230)
                                                .clipped()
                                        } else if phase.error != nil {
                                            Color.gray.opacity(0.2)
                                                .frame(height: 230)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .font(.title2)
                                                        .foregroundStyle(.secondary)
                                                )
                                        } else {
                                            ProgressView()
                                                .frame(height: 230)
                                        }
                                    }
                                    .frame(height: 230)
                                    .cornerRadius(10)
                                } else {
                                    Color.gray.opacity(0.2)
                                        .frame(height: 230)
                                        .cornerRadius(10)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.title2)
                                                .foregroundStyle(.secondary)
                                        )
                                }
                                Text(movie.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                            }
                            .onTapGesture { onMovieSelect(movie); dismiss() }
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
                    Button("Close", action: { dismiss() })
                        .foregroundColor(Color(hex: "#F4CB43"))
                }
            }
            .toolbarBackground(Color(hex: "#181818"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

//HighRatedSection at the end of the file
struct HighRatedSection: View {
    let movies: [Movie]
    @Binding var currentIndex: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top Picks")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                if movies.indices.contains(currentIndex) {
                    Text(movies[currentIndex].title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "#F4CB43"))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding(.horizontal, 20)

            TabView(selection: $currentIndex) {
                ForEach(Array(movies.enumerated()), id: \.1.id) { idx, movie in
                    ZStack(alignment: .bottom) {
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
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                            startPoint: .top, endPoint: .bottom
                        )
                        .frame(height: 100)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        HStack {
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(radius: 4)
                                if let rating = movie.rating {
                                    Label(String(format: "%.1f", rating), systemImage: "star.fill")
                                        .foregroundColor(Color(hex: "#F4CB43"))
                                        .font(.system(size: 15, weight: .semibold))
                                }
                            }
                            Spacer()
                        }
                        .padding([.horizontal, .bottom], 16)
                    }
                    .frame(height: 270)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 20)
                    .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 270)
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
