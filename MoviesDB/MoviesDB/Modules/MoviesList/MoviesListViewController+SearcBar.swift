//
//  MoviesListViewController+SearcBar.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import UIKit

extension MoviesListViewController: UISearchBarDelegate {
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          searchTextPublisher.send(searchText) // Send text changes to the Combine pipeline.
      }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchPopularMovies()
        tableView.setContentOffset(.zero, animated: true)
    }
}
