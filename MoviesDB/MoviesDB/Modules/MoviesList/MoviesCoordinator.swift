//
//  MoviesCoordinator.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import UIKit

class MoviesCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MoviesViewModel()
        let moviesListVC = MoviesListViewController(viewModel: viewModel)
        moviesListVC.coordinator = self
        navigationController.pushViewController(moviesListVC, animated: true)
    }

    func showMovieDetails(for movieId: Int) {
        let movieDetailsCoordinator = MovieDetailsCoordinator(navigationController: navigationController, movieId: movieId)
        addChildCoordinator(movieDetailsCoordinator)
        movieDetailsCoordinator.start()
    }
}
