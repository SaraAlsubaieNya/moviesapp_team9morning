//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Sara Alsubaie on 01/01/2026.
//
import Foundation
import Combine // Needed for ObservableObject and @Published

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: MoviesService

    init(service: MoviesService? = nil) {
        if let service = service {
            self.service = service
        } else {
            self.service = MoviesService.shared
        }
    }

    func loadMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            movies = try await service.fetchMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
