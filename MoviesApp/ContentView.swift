import SwiftUI

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let genre: String
    let rating: Double?
    let reviews: Int?
    let duration: String?
}

let highRatedMovie = Movie(
    title: "Top Gun",
    imageName: "High rated movie 1",
    genre: "Action",
    rating: 4.8,
    reviews: 56,
    duration: "2 hr 6 min"
)

let dramaMovies = [
    Movie(title: "Shawshank", imageName: "shawhank", genre: "Drama", rating: nil, reviews: nil, duration: nil),
    Movie(title: "A Star is Born", imageName: "star", genre: "Drama", rating: nil, reviews: nil, duration: nil)
]

let comedyMovies = [
    Movie(title: "World's Greatest Dad", imageName: "image 3", genre: "Comedy", rating: nil, reviews: nil, duration: nil),
    Movie(title: "Popstar", imageName: "image 4", genre: "Comedy", rating: nil, reviews: nil, duration: nil)
]

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    
                    // Search bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        Text("Search for Movie name , actors ...")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color(hex: "#232323"))
                    .cornerRadius(12)
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
                    
                    // High Rated section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("High Rated")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        ZStack(alignment: .bottomLeading) {
                            Image(highRatedMovie.imageName)
                                .resizable()
                                .aspectRatio(16/9, contentMode: .fill)
                                .frame(height: 220)
                                .clipped()
                                // No .cornerRadius here for square corners
                            
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.05), Color.black.opacity(0.90)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(highRatedMovie.title)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                HStack(spacing: 10) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color(hex: "#F4CB43"))
                                        .font(.system(size: 14))
                                    Text(String(format: "%.1f", highRatedMovie.rating ?? 0))
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("out of 5")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                    if let reviews = highRatedMovie.reviews {
                                        Text("(\(reviews))")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                    }
                                }
                                if let duration = highRatedMovie.duration {
                                    Text("\(highRatedMovie.genre), \(duration)")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                }
                            }
                            .padding(18)
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        
                        // Carousel dots (simulate 5 dots, 1 selected), centered
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
                    
                    // Drama Section
                    SectionView(section: "Drama", movies: dramaMovies)
                    
                    // Comedy Section
                    SectionView(section: "Comedy", movies: comedyMovies)
                    
                    Spacer(minLength: 16)
                }
                .background(Color(hex: "#181818").ignoresSafeArea())
            }
            .background(Color(hex: "#181818").ignoresSafeArea())
            .navigationTitle("Movies Center")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SectionView: View {
    let section: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(section)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("Show more")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#F4CB43"))
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 14) {
                ForEach(movies) { movie in
                    Image(movie.imageName)
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                        .frame(width: 155, height: 210)
                        // No .cornerRadius here for square corners
                        .clipped()
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// Helper for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
