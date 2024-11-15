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
    private let movieId: Int

    init(navigationController: UINavigationController, movieId: Int) {
        self.navigationController = navigationController
        self.movieId = movieId
    }

    func start() {
        let movieDetailsViewModel = MovieDetailsViewModel(movieId: movieId)
        let movieDetailsVC = MovieDetailsViewController(viewModel: movieDetailsViewModel)
        navigationController.pushViewController(movieDetailsVC, animated: true)
    }
}
