//
//  AppEnvironment.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import Foundation

class AppEnvironment {
    static let baseURL: String = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL not set in Build Settings")
        }
        return baseURL
    }()
    
    static let apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not set in Build Settings")
        }
        return apiKey
    }()
}
