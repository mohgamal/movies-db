//
//  APIClient.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import Combine
import Foundation

class MoviesListAPIClient: MoviesListServiceProtocol {
    func fetchPopularMovies() -> AnyPublisher<MovieResponse, Error> {
        let url = MoviesEndpoint.popularMovies.url
        return fetchData(from: url)
    }
    
    func searchMovies(query: String) -> AnyPublisher<MovieResponse, Error> {
        let url = MoviesEndpoint.searchMovies(query: query).url
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
