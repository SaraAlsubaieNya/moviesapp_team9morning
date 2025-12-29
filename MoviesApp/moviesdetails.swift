//
//  moviesdetails.swift
//  MoviesApp
//
//  Created by Ghady Omar on 23/12/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
        ZStack(alignment: .topLeading) {
            Color.black
                .ignoresSafeArea()
            
            ZStack(alignment: .bottom) {
                Image("showshankscover")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 500)
                    .clipped()
                    .ignoresSafeArea(edges: .top)
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(0.8),
                        Color.black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
            }


            HStack {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(Color("bookmark"))
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .clipShape(Circle())
                
                Spacer()
                
                HStack(spacing: 10) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(Color("bookmark"))
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                    
                    Image(systemName: "bookmark")
                        .font(.title2)
                        .foregroundColor(Color("bookmark"))
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 0)
    
            VStack {
                Spacer()
                Text("Showshank")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .lineSpacing(0)
                    .position(x: 17 + 149/2, y: 360 + 33/2)
            }
            .frame(height: 400)
            .padding(.horizontal, 20)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        

            VStack(alignment: .leading, spacing: 20) {
                
                // تفاصيل الفلم
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Duration")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                        Text("2 hours 22 mins")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .medium))
                        Text("Genre")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                        Text("Drama")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .medium))
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Language")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                        Text("English")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .medium))
                        Text("Age")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                        Text("+18")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .medium))
                    }
                }
                
                // قصة الفلم
                VStack(alignment: .leading, spacing: 10) {
                    Text("Story")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Synopsis. In 1947, Andy Dufresne (Tim Robbins), a banker in Maine, is convicted of murdering his wife and her lover, a golf pro. Since the state of Maine has no death penalty, he is given two consecutive life sentences and sent to the notoriously harsh Shawshank Prison.")
                        .foregroundColor(.gray)
                        .font(.system(size: 15, weight: .medium))
                        .lineLimit(nil)
                }
               // تقييم الفلم
                VStack(alignment: .leading, spacing: 10) {
                    Text("IMDb Rating")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                    Text("F9.3 / 10")
                        .foregroundColor(.gray)
                        .font(.system(size: 15, weight: .medium))
                    
                    
                    Rectangle()
                        .fill(Color.gray.opacity(1))
                        .frame(width: 358, height: 0.4)
                        .padding(.top, 10)
                        .padding(.leading, 16)
                    
                    // الدايركتور
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Director")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                        
                        Image("Directorimage")
                            .resizable()
                            .frame(width: 76, height: 76)
                            .clipShape(Circle())
                            .padding(.top, 10)
                        
                        Text("Frank Darabont")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .medium))
                    }
                    
                    // نجوم الفلم
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Stars")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                        
                        HStack(spacing: 10) {
                            VStack {
                                Image("star1")
                                    .resizable()
                                    .frame(width: 76, height: 76)
                                    .clipShape(Circle())
                                Text("Tim Robbins")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15, weight: .medium))
                            }
                            VStack {
                                Image("star2")
                                    .resizable()
                                    .frame(width: 76, height: 76)
                                    .clipShape(Circle())
                                Text("Morgan Freeman")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15, weight: .medium))
                            }
                            VStack {
                                Image("star3")
                                    .resizable()
                                    .frame(width: 76, height: 76)
                                    .clipShape(Circle())
                                Text("Bob Gunton")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15, weight: .medium))
                            }
                        }
                    }
                    Rectangle()
                        .fill(Color.gray.opacity(1))
                        .frame(width: 358, height: 0.4)
                        .padding(.top, 10)
                        .padding(.leading, 16)
                }
                    VStack {
                        Text("Rating & Reviews")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("4.8")
                            .foregroundColor(.gray)
                            .font(.system(size: 39, weight: .medium))
                        Text("out of 5")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .medium))
                    }
            }
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("card"))
                .frame(width: 372, height: 188)
                .overlay(
                    VStack(alignment: .leading, spacing: 10){
                        HStack(alignment: .top) {
                            Image("afnan")
                                .resizable()
                                .foregroundColor(Color("bookmark"))
                                .frame(width: 38, height: 38)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text("Afnan Abdullah")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .font(.system(size: 13, weight: .medium))
                                
                                HStack(spacing: 0){
                                    Image(systemName:"star.fill")
                                        .font(.subheadline)
                                        .foregroundColor(Color("bookmark"))
                                    Image(systemName:"star.fill")
                                        .font(.subheadline)
                                        .foregroundColor(Color("bookmark"))
                                    Image(systemName:"star.fill")
                                        .font(.subheadline)
                                        .foregroundColor(Color("bookmark"))
                                    Image(systemName:"star")
                                        .font(.subheadline)
                                        .foregroundColor(Color("bookmark"))
                                    Image(systemName:"star")
                                        .font(.subheadline)
                                        .foregroundColor(Color("bookmark"))
                                }
                                Text("This is an engagingly simple, good-hearted film, with just enough darkness around the edges to give contrast and relief to its glowingly benign view of human nature.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 13, weight: .regular))
                            }
                        }
                    }
                    .padding()
                )
                .shadow(radius: 10)
        }
        .padding(.leading, 15)
        .padding(.trailing, 15)

    }
}
    
   

#Preview {
    ContentView()
}
