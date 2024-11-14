//
//  MovieDetailsCoordinator.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import UIKit

class MovieDetailsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let movie: Movie

    init(navigationController: UINavigationController, movie: Movie) {
        self.navigationController = navigationController
        self.movie = movie
    }

    func start() {
//        let movieDetailsViewModel = MovieDetailsViewModel(movie: movie)
//        let movieDetailsVC = MovieDetailsViewController(viewModel: movieDetailsViewModel)
//        movieDetailsVC.coordinator = self
//        navigationController.pushViewController(movieDetailsVC, animated: true)
    }
    
    func didFinish() {
        // Optionally, remove this coordinator from its parent
        // When exiting the details screen
    }
}
