//
//  MovieDetailsViewModel.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import Combine
import Foundation

class MovieDetailsViewModel {
    @Published var movieDetails: MovieDetails?
    @Published var similarMovies: [Movie] = []
    @Published var credits: MovieCredits?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    let movieId: Int
    
    private let apiService: MovieDetailsServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(apiService: MovieDetailsServiceProtocol = MovieDetailsAPIClient(), movieId: Int) {
        self.apiService = apiService
        self.movieId = movieId
    }

    func fetchMovieDetails(movieId: Int) {
        isLoading = true
        errorMessage = nil
        
        let movieDetailsPublisher = apiService.fetchMovieDetails(movieId: movieId)
        let similarMoviesPublisher = apiService.fetchSimilarMovies(movieId: movieId)
        let creditsPublisher = apiService.fetchMovieCredits(movieId: movieId)

        Publishers.Zip3(movieDetailsPublisher, similarMoviesPublisher, creditsPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to fetch movie details: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] movieDetails, similarMovies, credits in
                guard let self else { return }
                self.movieDetails = movieDetails
                self.similarMovies = Array(similarMovies.results.prefix(5))
                self.credits = credits
            }
            .store(in: &cancellables)
    }
}
