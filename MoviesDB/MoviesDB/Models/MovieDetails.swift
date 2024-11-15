//
//  MovieDetails.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import Foundation

struct MovieDetails: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let runtime: Int
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case runtime, genres
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
