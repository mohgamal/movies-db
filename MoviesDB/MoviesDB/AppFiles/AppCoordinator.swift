//
//  AppCoordinator.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let moviesCoordinator = MoviesCoordinator(navigationController: navigationController)
        addChildCoordinator(moviesCoordinator)
        moviesCoordinator.start()
    }
}
