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

class MoviesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    weak var coordinator: MoviesCoordinator?
    private let tableView = UITableView()
    private var searchController: UISearchController!
    private var searchTextPublisher = PassthroughSubject<String, Never>()
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

        setupSearchController()
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

    // MARK: - Setup Search Controller
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - UISearchBarDelegate for Text Changes and Cancel Action
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextPublisher.send(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Reset to popular movies when cancel is clicked
        viewModel.fetchPopularMovies()
        searchBar.text = ""
        
        // Scroll to the top of the table view
        if !viewModel.movies.isEmpty {
            tableView.setContentOffset(.zero, animated: true)
        }
    }

    // MARK: - Setup Table View
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        viewModel.fetchMovieDetail(movieId: movie.id)
    }
}
