//
//  MoviesListViewModel.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import Foundation
import Combine

class MoviesViewModel {
    // Published properties to observe changes in the view
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var selectedMovie: Movie?

    private let apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // Injecting the APIServiceProtocol allows for easy testing and mocking
    init(apiService: APIServiceProtocol = APIClient()) {
        self.apiService = apiService
    }
    
    // Fetch popular movies
    func fetchPopularMovies() {
        isLoading = true  // Start loading
        apiService.fetchPopularMovies()
            .sink { [weak self] completion in
                self?.isLoading = false  // Stop loading on completion
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch movies: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies.results
            }
            .store(in: &cancellables)
    }
    
    // Fetch details for a specific movie by its ID
    func fetchMovieDetail(movieId: Int) {
        isLoading = true
        apiService.fetchMovieDetail(movieId: movieId)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch movie details: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] movie in
                self?.selectedMovie = movie
            }
            .store(in: &cancellables)
    }
    
    // Search for movies based on a query
    func searchMovies(query: String) {
        isLoading = true
        apiService.searchMovies(query: query)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to search movies: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies.results
            }
            .store(in: &cancellables)
    }
}
