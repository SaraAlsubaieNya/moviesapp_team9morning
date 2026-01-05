import SwiftUI

struct moviedetails: View {
    let movie: Movie
    @Binding var showingAddReview: Bool // <--- for navigation to AddReviewView
    
    var body: some View {
        ScrollView {
            // الهيدر
            ZStack(alignment: .bottom) {
                if let imageURL = movie.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 500)
                                .clipped()
                                .ignoresSafeArea(edges: .top)
                        } else if phase.error != nil {
                            Color.gray.opacity(0.3)
                                .frame(height: 500)
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                )
                                .ignoresSafeArea(edges: .top)
                        } else {
                            ProgressView()
                                .frame(height: 500)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.3))
                                .ignoresSafeArea(edges: .top)
                        }
                    }
                } else {
                    Color.gray.opacity(0.3)
                        .frame(height: 500)
                        .ignoresSafeArea(edges: .top)
                }

                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(0.8),
                        Color.black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)

                HStack {
                    Text(movie.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)

                    Spacer()
                }
            }
            
            // تفاصيل الموفي
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Duration").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                        Text(movie.duration ?? "N/A").foregroundColor(.gray).font(.system(size: 15))
                        Text("Genre").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                        Text(movie.genres.joined(separator: ", ")).foregroundColor(.gray).font(.system(size: 15))
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Language").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                        Text("English").foregroundColor(.gray).font(.system(size: 15))
                        Text("Age").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                        Text("+18").foregroundColor(.gray).font(.system(size: 15))
                    }
                }
                
                // قصة الموفي
                VStack(alignment: .leading, spacing: 10) {
                    Text("Story").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                    Text("Synopsis. In 1947, Andy Dufresne (Tim Robbins), a banker in Maine, is convicted of murdering his wife and her lover, a golf pro. Since the state of Maine has no death penalty, he is given two consecutive life sentences and sent to the notoriously harsh Shawshank Prison.")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }
                
                // التقييم
                VStack(alignment: .leading, spacing: 10) {
                    Text("IMDb Rating").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                    Text(String(format: "%.1f / 10", movie.rating ?? 0)).foregroundColor(.gray).font(.system(size: 15))
                    Divider().background(Color.gray)
                    
                    // الدايركتور
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Director").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                        Image("Directorimage")
                            .resizable()
                            .frame(width: 76, height: 76)
                            .clipShape(Circle())
                        Text("Frank Darabont").foregroundColor(.gray).font(.system(size: 15))
                    }
                    
                    // النجوم
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Stars").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                        HStack(spacing: 10) {
                            StarView(name: "Tim Robbins", image: "star1")
                            StarView(name: "Morgan Freeman", image: "star2")
                            StarView(name: "Bob Gunton", image: "star3")
                        }
                    }
                    Divider().background(Color.gray)
                }
                
                // التقييم
                VStack {
                    Text("Rating & Reviews").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                    Text(String(format: "%.1f", (movie.rating ?? 0) / 2)).foregroundColor(.gray).font(.system(size: 39, weight: .medium))
                    Text("out of 5").foregroundColor(.gray).font(.system(size: 15))
                }
            }
            .padding(.horizontal, 30)
            
            // الكاردز حق التعليقات
            ZStack {
                Color.moviesCard
                    .cornerRadius(20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ReviewCard(name: "Afnan Abdullah", image: "afnan", rating: 3, review: "This is an engagingly simple, good-hearted film, with just enough darkness around the edges to give contrast and relief to its glowingly benign view of human nature.")
                        ReviewCard(name: "Sarah Ahmad", image: "sarahahmed", rating: 4, review: "A tough, complex story [told] with clarity, compassion and considerable dramatic force.")
                        ReviewCard(name: "Abdullah Sharif", image: "abdullahsharif", rating: 3, review: "It doesn't matter how we think we remember the moments, how they look now, in this edition, will force a shift in memory that we'll most likely be grateful for.")
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 200)
            }
            .frame(height: 200)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            
            Button(action: {
                showingAddReview = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 20))
                    
                    Text("Write a review")
                        .font(.system(size: 18, weight: .medium))
                }
                .foregroundColor(Color("bookmark"))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("bookmark"), lineWidth: 2)
                )
                .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 10)
        .background(Color.black.ignoresSafeArea())
        .navigationBarTitle(movie.title, displayMode: .inline)
        .toolbarBackground(Color("navigationbar"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // عرض النجوم
    struct StarView: View {
        let name: String
        let image: String
        var body: some View {
            VStack {
                Image(image).resizable().frame(width: 76, height: 76).clipShape(Circle())
                Text(name).foregroundColor(.gray).font(.system(size: 15))
            }
        }
    }
    
    // عرض الكارد
    struct ReviewCard: View {
        let name: String
        let image: String
        let rating: Int
        let review: String

        private var currentDate: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: Date())
        }

        var body: some View {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.moviesCard)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top, spacing: 12) {
                            Image(image)
                                .resizable()
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(name)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .semibold))

                                HStack(spacing: 2) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < rating ? "star.fill" : "star")
                                            .font(.caption2)
                                            .foregroundColor(Color("bookmark"))
                                    }
                                }
                            }

                            Spacer()
                        }

                        Text(review)
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()

                        HStack {
                            Spacer()
                            Text(currentDate)
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                    }
                    .padding(14)
                )
                .frame(width: 300)
                .shadow(radius: 5)
        }
    }
}
