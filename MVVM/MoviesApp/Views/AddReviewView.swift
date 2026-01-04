//
//  AddReviewView.swift
//  MoviesApp
//
//  Created by Ghady Al Omar on 11/07/1447 AH.
//

import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var reviewText: String = ""
    @State private var rating: Int = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                Spacer().frame(height: 12)
                Divider().background(Color.white.opacity(0.15))

                // المحتوى
                VStack(alignment: .leading, spacing: 22) {

                    // Review
                    Text("Review")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.top, 22)

                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 358, height: 146)

                        TextEditor(text: $reviewText)
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.white)
                            .padding(12)
                            .frame(height: 150)

                        if reviewText.isEmpty {
                            Text("Enter your review")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 18)
                        }
                    }
// التقييم بالنجوم
                    HStack {
                        Text("Rating")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))

                        Spacer()

                        HStack(spacing: 10) {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: i <= rating ? "star.fill" : "star")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color("bookmark"))
                                    .onTapGesture { rating = i }
                            }
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding(.horizontal, 22)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(Color("bookmark"))
                    .font(.system(size: 16, weight: .medium))
                }
            }

            ToolbarItem(placement: .principal) {
                Text("Write a review")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Add")
                    .foregroundColor(Color("bookmark"))
                    .font(.system(size: 16, weight: .semibold))
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddReviewView()
    }
    .preferredColorScheme(.dark)
}
