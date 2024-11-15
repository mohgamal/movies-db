//
//  MovieDetailsEndpoint.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import Foundation

enum MovieDetailsEndpoint {
    case movieDetail(movieId: Int)
    case similarMovies(movieId: Int)
    case movieCredits(movieId: Int)
    
    var url: URL {
        switch self {
        case .movieDetail(let movieId):
            return makeURL(path: "/movie/\(movieId)")
        case .similarMovies(let movieId):
            return makeURL(path: "/movie/\(movieId)/similar")
        case .movieCredits(let movieId):
            return makeURL(path: "/movie/\(movieId)/credits")
        }
    }
    
    private func makeURL(path: String, queryItems: [String: String] = [:]) -> URL {
        var components = URLComponents(string: AppEnvironment.baseURL)!
        components.path += path
        var queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "api_key", value: AppEnvironment.apiKey))
        components.queryItems = queryItems
        return components.url!
    }
}
