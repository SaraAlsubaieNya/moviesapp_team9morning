//
//  profile.swift
//  MoviesApp
//
//  Created by Sara Alsubaie on 23/12/2025.
//

//  Created by Sara Alsubaie on 23/12/2025.
//

import SwiftUI

struct ProfileView: View {
    struct SavedMovie: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let imageName: String
    }

    private let savedMovies: [SavedMovie] = [
        .init(title: "World's Greatest Dad", imageName: "image 3"),
        .init(title: "The Shawshank Redemption", imageName: "image 3"),
        .init(title: "A Star Is Born", imageName: "image 3")
    ]

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

                Button {
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray4))
                            Image(systemName: "person.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 48, height: 48)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Sarah Abdullah")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text("Xxxx234@gmail.com")
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

                    let columns = Array(
                        repeating: GridItem(.fixed(fixedItemWidth), spacing: gridSpacing, alignment: .top),
                        count: columnsCount
                    )

                    LazyVGrid(columns: columns, alignment: .leading, spacing: gridSpacing) {
                        ForEach(savedMovies) { movie in
                            ZStack {
                                if let uiImage = UIImage(named: movie.imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Color.gray.opacity(0.2)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.title2)
                                                .foregroundStyle(.secondary)
                                        )
                                }
                            }
                            .frame(width: fixedItemWidth, height: fixedItemHeight)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                            .contentShape(Rectangle())
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        VStack {
            NavigationLink("Open Profile") {
                ProfileView()
            }
            .padding()
        }
        .navigationTitle("Home")
    }
}
