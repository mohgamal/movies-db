//
//  MockMovieDetailsAPIClient.swift
//  MoviesDBTests
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import Foundation
import Combine
@testable import MoviesDB

class MockMovieDetailsAPIClient: MovieDetailsServiceProtocol {
    var fetchMovieDetailsResult: Result<MovieDetails, Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    var fetchSimilarMoviesResult: Result<MovieResponse, Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    var fetchMovieCreditsResult: Result<MovieCredits, Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))

    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetails, Error> {
        return Future { promise in
            promise(self.fetchMovieDetailsResult)
        }.eraseToAnyPublisher()
    }

    func fetchSimilarMovies(movieId: Int) -> AnyPublisher<MoviesDB.MovieResponse, any Error> {
        return Future { promise in
            promise(self.fetchSimilarMoviesResult)
        }.eraseToAnyPublisher()
    }

    func fetchMovieCredits(movieId: Int) -> AnyPublisher<MovieCredits, Error> {
        return Future { promise in
            promise(self.fetchMovieCreditsResult)
        }.eraseToAnyPublisher()
    }
}
