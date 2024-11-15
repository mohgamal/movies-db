//
//  MockMoviesListAPIClient.swift
//  MoviesDBTests
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//
import Foundation
import Combine
@testable import MoviesDB

class MockMoviesListService: MoviesListServiceProtocol {
    var fetchPopularMoviesResult: Result<MovieResponse, Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    var searchMoviesResult: Result<MovieResponse, Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    
    func fetchPopularMovies() -> AnyPublisher<MovieResponse, Error> {
        return Future { promise in
            promise(self.fetchPopularMoviesResult)
        }.eraseToAnyPublisher()
    }
    
    func searchMovies(query: String) -> AnyPublisher<MovieResponse, Error> {
        return Future { promise in
            promise(self.searchMoviesResult)
        }.eraseToAnyPublisher()
    }
}
