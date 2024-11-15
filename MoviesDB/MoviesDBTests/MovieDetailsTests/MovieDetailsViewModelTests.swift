//
//  MovieDetailsViewModelTests.swift
//  MoviesDBTests
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import Foundation
import XCTest
import Combine
@testable import MoviesDB

class MovieDetailsViewModelTests: XCTestCase {
    var viewModel: MovieDetailsViewModel!
    var mockAPIService: MockMovieDetailsAPIClient!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIService = MockMovieDetailsAPIClient()
        viewModel = MovieDetailsViewModel(apiService: mockAPIService, movieId: 0)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchMovieDetailsSuccess() {
        // Setup mock data
        let mockMovieDetails = MovieDetails(id: 1, title: "Test Movie", overview: "Overview", releaseDate: "2023-01-01", posterPath: nil, runtime: 120, genres: [])
        
        let mockSimilarMovies = [Movie(id: 2, title: "Similar Movie", overview: "", posterPath: "", releaseDate: "", voteAverage: 0, voteCount: 0)]
        let mockCredits = MovieCredits(cast: [], crew: [])

        mockAPIService.fetchMovieDetailsResult = .success(mockMovieDetails)
        mockAPIService.fetchSimilarMoviesResult = .success(MovieResponse(page: 0, results: mockSimilarMovies, totalPages: 0, totalResults: 0))
        mockAPIService.fetchMovieCreditsResult = .success(mockCredits)

        // Expectations
        let detailsExpectation = expectation(description: "Fetch movie details")
        let similarMoviesExpectation = expectation(description: "Fetch similar movies")
        let creditsExpectation = expectation(description: "Fetch movie credits")

        // Subscribe to changes
        viewModel.$movieDetails.sink { details in
            if details != nil {
                detailsExpectation.fulfill()
            }
        }.store(in: &cancellables)

        viewModel.$similarMovies.sink { movies in
            if !movies.isEmpty {
                similarMoviesExpectation.fulfill()
            }
        }.store(in: &cancellables)

        viewModel.$credits.sink { credits in
            if credits != nil {
                creditsExpectation.fulfill()
            }
        }.store(in: &cancellables)

        // Act
        viewModel.fetchMovieDetails(movieId: 1)

        // Wait for expectations
        wait(for: [detailsExpectation, similarMoviesExpectation, creditsExpectation], timeout: 2.0)

        // Assert
        XCTAssertEqual(viewModel.movieDetails?.title, "Test Movie")
        XCTAssertEqual(viewModel.similarMovies.first?.title, "Similar Movie")
        XCTAssertNotNil(viewModel.credits)
    }

    func testFetchMovieDetailsFailure() {
        // Setup mock error
        let mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockAPIService.fetchMovieDetailsResult = .failure(mockError)
        mockAPIService.fetchSimilarMoviesResult = .failure(mockError)
        mockAPIService.fetchMovieCreditsResult = .failure(mockError)

        // Expectations
        let errorExpectation = expectation(description: "Error state set")

        // Subscribe to errorMessage
        viewModel.$errorMessage.sink { errorMessage in
            if errorMessage != nil {
                errorExpectation.fulfill()
            }
        }.store(in: &cancellables)

        // Act
        viewModel.fetchMovieDetails(movieId: 1)

        // Wait for expectations
        wait(for: [errorExpectation], timeout: 2.0)

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Failed to fetch movie details: The operation couldn’t be completed. (TestError error 500.)")
        XCTAssertNil(viewModel.movieDetails)
        XCTAssertTrue(viewModel.similarMovies.isEmpty)
        XCTAssertNil(viewModel.credits)
    }
}
