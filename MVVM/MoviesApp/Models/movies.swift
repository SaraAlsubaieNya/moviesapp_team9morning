//
//  movies.swift
//  MoviesApp
//
//  Created by Sara Alsubaie on 01/01/2026.
//

import Foundation

struct Movie: Identifiable, Hashable {
    let id: String
    let title: String
    let imageURL: URL?
    let genres: [String]
    let rating: Double?
    let duration: String?

    init(from record: AirtableMoviesResponse.Record) {
        self.id = record.id
        self.title = record.fields.name ?? "Untitled"
        self.imageURL = URL(string: record.fields.poster ?? "")
        self.genres = record.fields.genre ?? []
        self.rating = record.fields.IMDb_rating
        self.duration = record.fields.runtime
    }

    init(id: String,
         title: String,
         imageURL: URL?,
         genres: [String],
         rating: Double?,
         duration: String?) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.genres = genres
        self.rating = rating
        self.duration = duration
    }

    var genreText: String? {
        genres.first
    }
}
