//
//  MovieDetailsView.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import UIKit

class MovieDetailsView: UIView {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let genresLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(overviewLabel)
        addSubview(releaseDateLabel)
        addSubview(runtimeLabel)
        addSubview(genresLabel)

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false

        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.textColor = .gray
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false

        runtimeLabel.font = UIFont.systemFont(ofSize: 14)
        runtimeLabel.textColor = .gray
        runtimeLabel.translatesAutoresizingMaskIntoConstraints = false

        genresLabel.font = UIFont.systemFont(ofSize: 14)
        genresLabel.numberOfLines = 0
        genresLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            runtimeLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 4),
            runtimeLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            runtimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            genresLabel.topAnchor.constraint(equalTo: runtimeLabel.bottomAnchor, constant: 8),
            genresLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            genresLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func configure(with details: MovieDetails) {
        titleLabel.text = details.title
        overviewLabel.text = details.overview
        releaseDateLabel.text = "Release Date: \(details.releaseDate)"
        runtimeLabel.text = "Runtime: \(details.runtime) minutes"
        genresLabel.text = "Genres: \(details.genres.map { $0.name }.joined(separator: ", "))"

        if let posterPath = details.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            loadImage(from: url, into: posterImageView)
        } else {
            posterImageView.image = nil
        }
    }

    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
