//
//  MovieDetailsViewController.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {

    private let viewModel: MovieDetailsViewModel
    private var cancellables = Set<AnyCancellable>()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let movieDetailsView = MovieDetailsView()
    private let similarMoviesView = SimilarMoviesView()
    private let movieCreditsView = MovieCreditsView()

    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupBindings()
        viewModel.fetchMovieDetails(movieId: viewModel.movieId)
    }

    private func setupScrollView() {
        
        // Add scrollView and contentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add loading indicator to the main view
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Create and add section titles
        let detailsTitleLabel = createSectionTitleLabel(text: "Movie Details")
        let similarMoviesTitleLabel = createSectionTitleLabel(text: "Similar Movies")
        let creditsTitleLabel = createSectionTitleLabel(text: "Movie Credits")

        // Add subviews to contentView
        contentView.addSubview(detailsTitleLabel)
        contentView.addSubview(movieDetailsView)
        contentView.addSubview(similarMoviesTitleLabel)
        contentView.addSubview(similarMoviesView)
        contentView.addSubview(creditsTitleLabel)
        contentView.addSubview(movieCreditsView)

        // Configure constraints for Movie Details section
        detailsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDetailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            detailsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            movieDetailsView.topAnchor.constraint(equalTo: detailsTitleLabel.bottomAnchor, constant: 8),
            movieDetailsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieDetailsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Configure constraints for Similar Movies section
        similarMoviesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        similarMoviesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            similarMoviesTitleLabel.topAnchor.constraint(equalTo: movieDetailsView.bottomAnchor, constant: 16),
            similarMoviesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            similarMoviesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            similarMoviesView.topAnchor.constraint(equalTo: similarMoviesTitleLabel.bottomAnchor, constant: 8),
            similarMoviesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            similarMoviesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            similarMoviesView.heightAnchor.constraint(equalToConstant: 200) // Fixed height for simplicity
        ])

        // Configure constraints for Movie Credits section
        creditsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieCreditsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creditsTitleLabel.topAnchor.constraint(equalTo: similarMoviesView.bottomAnchor, constant: 16),
            creditsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            creditsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            movieCreditsView.topAnchor.constraint(equalTo: creditsTitleLabel.bottomAnchor, constant: 8),
            movieCreditsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieCreditsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            movieCreditsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16) // Ensure it extends the scrollable area
        ])
    }

    private func setupBindings() {
        // Bind movie details
        viewModel.$movieDetails
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] details in
                guard let self else { return }
                self.title = details.title // Set the movie title as the screen title
                self.movieDetailsView.configure(with: details)
            }
            .store(in: &cancellables)

        // Bind similar movies
        viewModel.$similarMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self else { return }
                self.similarMoviesView.configure(with: movies)
            }
            .store(in: &cancellables)

        // Bind movie credits
        viewModel.$credits
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] credits in
                guard let self else { return }
                self.movieCreditsView.configure(with: credits)
            }
            .store(in: &cancellables)

        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)

        // Bind error state
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self else { return }
                self.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func updateContentLayout() {
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
    }
    
    private func createSectionTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
