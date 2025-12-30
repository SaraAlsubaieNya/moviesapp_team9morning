import SwiftUI

struct movieView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                // الهيدر
                ZStack(alignment: .bottom) {
                    Image("showshankscover")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 500)
                        .clipped()
                        .ignoresSafeArea(edges: .top)

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
                        Text("Showshank")
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
                            Text("2 hours 22 mins").foregroundColor(.gray).font(.system(size: 15))
                            Text("Genre").foregroundColor(.white).font(.system(size: 18, weight: .semibold))
                            Text("Drama").foregroundColor(.gray).font(.system(size: 15))
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
                        Text("9.3 / 10").foregroundColor(.gray).font(.system(size: 15))
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
                        Text("4.8").foregroundColor(.gray).font(.system(size: 39, weight: .medium))
                        Text("out of 5").foregroundColor(.gray).font(.system(size: 15))
                    }
                }
                .padding(.horizontal, 30)
                
                // الكاردز حق التعليقات
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
            .padding(.horizontal, 10)
            .background(Color.black.ignoresSafeArea())
            .navigationBarTitle("Shawshank", displayMode: .inline)
            .toolbarBackground(Color("navigationbar"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarItems(
                leading: Button(action: { print("Back tapped") }) {
                    Image(systemName: "chevron.left").foregroundColor(Color("bookmark"))
                },
                trailing: HStack {
                    Button(action: { print("Share tapped") }) { Image(systemName: "square.and.arrow.up").foregroundColor(Color("bookmark")) }
                    Button(action: { print("Bookmark tapped") }) { Image(systemName: "bookmark").foregroundColor(Color("bookmark")) }
                }
            )
        }
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
        
        var body: some View {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("card"))
                .frame(width: 300, height: 180)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Image(image).resizable().frame(width: 38, height: 38).clipShape(Circle())
                            VStack(alignment: .leading, spacing: 6) {
                                Text(name).foregroundColor(.white).font(.system(size: 13, weight: .medium))
                                HStack(spacing: 0) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < rating ? "star.fill" : "star")
                                            .font(.subheadline)
                                            .foregroundColor(Color("bookmark"))
                                    }
                                }
                                Text(review).foregroundColor(.white).font(.system(size: 13)).lineLimit(4)
                            }
                        }
                    }
                        .padding()
                )
                .shadow(radius: 10)
        }
    }
}

#Preview {
    movieView()
        .preferredColorScheme(.dark)
}
