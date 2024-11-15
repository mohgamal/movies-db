//
//  APIServiceProtocol.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import Foundation
import Combine

protocol MoviesListServiceProtocol {
    func fetchPopularMovies() -> AnyPublisher<MovieResponse, Error>
    func searchMovies(query: String) -> AnyPublisher<MovieResponse, Error>
}
