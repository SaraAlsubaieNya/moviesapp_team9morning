//
//  AirtableMoviesResponse.swift
//  MoviesApp
//
//  Created by Sara Alsubaie on 01/01/2026.
//
import Foundation

struct AirtableMoviesResponse: Codable {
    struct Record: Codable {
        let id: String
        let fields: Fields
    }
    struct Fields: Codable {
        let name: String?
        let poster: String?
        let genre: [String]?
        let IMDb_rating: Double?
        let runtime: String?
    }
    let records: [Record]
}

