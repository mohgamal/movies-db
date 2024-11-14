//
//  MoviesEndpoint.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import Foundation

enum MoviesEndpoint {
    case popularMovies
    case movieDetail(movieId: Int)
    case searchMovies(query: String)
    
    var url: URL {
        switch self {
        case .popularMovies:
            return makeURL(path: "/movie/popular")
        case .movieDetail(let movieId):
            return makeURL(path: "/movie/\(movieId)")
        case .searchMovies(let query):
            return makeURL(path: "/search/movie", queryItems: ["query": query])
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
