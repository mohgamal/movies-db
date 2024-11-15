//
//  MovieDetailsServiceProtocol.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import Foundation
import Combine

protocol MovieDetailsServiceProtocol {
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetails, Error>
    func fetchSimilarMovies(movieId: Int) -> AnyPublisher<MovieResponse, Error>
    func fetchMovieCredits(movieId: Int) -> AnyPublisher<MovieCredits, Error>
}
