//
//  APIServiceProtocol.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func fetchPopularMovies() -> AnyPublisher<MovieResponse, Error>
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<Movie, Error>
    func searchMovies(query: String) -> AnyPublisher<MovieResponse, Error>
}
