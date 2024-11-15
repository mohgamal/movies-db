//
//  MoviesListViewModel.swift
//  MoviesDBTests
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import XCTest
import Combine
@testable import MoviesDB

class MoviesViewModelTests: XCTestCase {
    var viewModel: MoviesViewModel!
    var mockService: MockMoviesListService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockMoviesListService()
        viewModel = MoviesViewModel(apiService: mockService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchPopularMoviesSuccess() {
        // Arrange
        let mockMovies = [
            Movie(id: 1, title: "Movie 1", overview: "", posterPath: "/path1.jpg", releaseDate: "", voteAverage: 0, voteCount: 0),
             Movie(id: 2, title: "Movie 2", overview: "", posterPath: "/path2.jpg", releaseDate: "", voteAverage: 0, voteCount: 0)
        ]
        let mockResponse = MovieResponse(page: 0, results: mockMovies, totalPages: 1, totalResults: 2)
        mockService.fetchPopularMoviesResult = .success(mockResponse)
        
        let moviesExpectation = expectation(description: "Movies should be loaded")
        let loadingExpectation = expectation(description: "Loading state should update")

        // Act
        viewModel.fetchPopularMovies()

        // Assert
        viewModel.$movies
            .sink { movies in
                if movies.count == 2{
                    moviesExpectation.fulfill()
                }
              
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .sink { isLoading in
                if !isLoading {
                    loadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [moviesExpectation, loadingExpectation], timeout: 2.0)
    }

    func testFetchPopularMoviesFailure() {
        // Arrange
        let mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockService.fetchPopularMoviesResult = .failure(mockError)
        
        let errorExpectation = expectation(description: "Error message should be set")
        let loadingExpectation = expectation(description: "Loading state should update")

        // Act
        viewModel.fetchPopularMovies()

        // Assert
        viewModel.$errorMessage.sink { errorMessage in
            if errorMessage != nil {
                errorExpectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { isLoading in
                if !isLoading {
                    loadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [errorExpectation, loadingExpectation], timeout: 2.0)
    }

    func testSearchMoviesSuccess() {
        // Arrange
        let mockMovies = [
            Movie(id: 3, title: "Search Movie 1", overview: "", posterPath: "/path1.jpg", releaseDate: "", voteAverage: 0, voteCount: 0),
             Movie(id: 4, title: "Search Movie 2", overview: "", posterPath: "/path2.jpg", releaseDate: "", voteAverage: 0, voteCount: 0)
        ]

        let mockResponse = MovieResponse(page: 0, results: mockMovies, totalPages: 1, totalResults: 2)
        mockService.searchMoviesResult = .success(mockResponse)
        
        let moviesExpectation = expectation(description: "Movies should be loaded")
        let loadingExpectation = expectation(description: "Loading state should update")

        // Act
        viewModel.searchMovies(query: "Search")

        // Assert
        viewModel.$movies
            .sink { movies in
                if movies.count == 2{
                    moviesExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .sink { isLoading in
                if !isLoading {
                    loadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [moviesExpectation, loadingExpectation], timeout: 2.0)
    }

    func testSearchMoviesFailure() {
        // Arrange
        let mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockService.searchMoviesResult = .failure(mockError)
        
        
        let errorExpectation = expectation(description: "Error message should be set")
        let loadingExpectation = expectation(description: "Loading state should update")

        // Act
        viewModel.searchMovies(query: "Search")

        // Assert
        viewModel.$errorMessage.sink { errorMessage in
            if errorMessage != nil {
                errorExpectation.fulfill()
            }
        }.store(in: &cancellables)

        viewModel.$isLoading
            .sink { isLoading in
                if !isLoading {
                    loadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [errorExpectation, loadingExpectation], timeout: 2.0)
    }
}
