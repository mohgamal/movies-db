//
//  MovieDetailsAPIClient.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import Combine
import Foundation

class MovieDetailsAPIClient: MovieDetailsServiceProtocol {
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetails, Error> {
        let url = MovieDetailsEndpoint.movieDetail(movieId: movieId).url
        return fetchData(from: url)
    }

    func fetchSimilarMovies(movieId: Int) -> AnyPublisher<MovieResponse, Error> {
        let url = MovieDetailsEndpoint.similarMovies(movieId: movieId).url
        return fetchData(from: url)
    }

    func fetchMovieCredits(movieId: Int) -> AnyPublisher<MovieCredits, Error> {
        let url = MovieDetailsEndpoint.movieCredits(movieId: movieId).url
        return fetchData(from: url)
    }

    private func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
