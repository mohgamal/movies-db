//
//  MoviesListViewController.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 14/11/2024.
//

import UIKit
import Combine
import UIKit
import Combine

class MoviesListViewController: UIViewController {
    
    weak var coordinator: MoviesCoordinator?
    public let tableView = UITableView()
    var searchTextPublisher = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: MoviesViewModel
    
    // Loading indicator
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchBar()
        setupTableView()
        setupLoadingIndicator()
        setupBindings()
        
        // Fetch popular movies initially
        if viewModel.movies.isEmpty {
            viewModel.fetchPopularMovies()
        }
    }
    
    // MARK: - Setup Loading Indicator
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        searchTextPublisher
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                
                if query.count >= 4 {
                    // Use viewModel's searchMovies function for the search
                    self.viewModel.searchMovies(query: query)
                } else if query.isEmpty {
                    // If the search query is cleared, return to popular movies
                    self.viewModel.fetchPopularMovies()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // Reload table view whenever movies list is updated
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showError(errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
