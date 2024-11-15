//
//  MovieCollectionViewCell.swift
//  MoviesDB
//
//  Created by Mohammed Abdelaty on 15/11/2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    private let posterImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(posterImageView)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with movie: Movie) {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
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
