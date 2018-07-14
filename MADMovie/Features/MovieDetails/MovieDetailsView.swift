//
//  MovieDetailsView.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

protocol MovieDetailsViewProtocol {
    func configureViews(movie: Movie)
    func render(results: (MoviesListContent, MovieImageInfo))
}

class MovieDetailsView: UIView {
    
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    let movieDetailsImageView = MovieDetailsImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let ratingLabel = UILabel()
    private let infoLabel = UILabel()
    private let similarMoviesStackView = MoviesStackView()
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var didSelectItem: ((Movie) -> ())? {
        get {
            return similarMoviesStackView.didSelectItem
        }
        set {
            similarMoviesStackView.didSelectItem = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureSubviesw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Configure UI
extension MovieDetailsView {
    private func configureSubviesw() {
        self.backgroundColor = UIColor.black
        
        self.configureScrollView()
        self.configureMovieDetailsImageView()
        self.configureLabels()
        self.configureMoviesStackViews()
        self.configureMainStackView()
        self.configureActivityIndicatorView()
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    private func configureMovieDetailsImageView() {
        movieDetailsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        movieDetailsImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    private func configureLabels() {
        titleLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 17)!
        titleLabel.textColor = UIColor.red
        titleLabel.numberOfLines = 0
        ratingLabel.font = UIFont(name: "AmericanTypewriter", size: 17)!
        ratingLabel.textColor = UIColor.gray
        dateLabel.font = UIFont(name: "AmericanTypewriter", size: 17)!
        dateLabel.textColor = UIColor.gray
        infoLabel.font = UIFont(name: "AmericanTypewriter", size: 17)!
        infoLabel.textColor = UIColor.white
        infoLabel.numberOfLines = 0
    }
    
    private func configureMoviesStackViews() {
        similarMoviesStackView.heightAnchor.constraint(equalToConstant: 260).isActive = true
    }
    
    private func configureMainStackView() {
        mainStackView.addArrangedSubview(movieDetailsImageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(ratingLabel)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(infoLabel)
        mainStackView.addArrangedSubview(similarMoviesStackView)
        
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        
        scrollView.addSubview(mainStackView)
        
        mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func configureActivityIndicatorView() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

//MARK: MoviesListViewProtocol
extension MovieDetailsView: MovieDetailsViewProtocol {
    
    func configureViews(movie: Movie) {
        ratingLabel.text = "Votes average: \(movie.voteAverage)"
        dateLabel.text = "Release date: \(movie.releaseDate)"
        titleLabel.text = movie.title.uppercased()
        infoLabel.text = movie.overview
        
        if let path = movie.posterPath {
            movieDetailsImageView.configureImageViews(posterPath: path)
        }
    }
    
    //MARK: MoviesListViewProtocol
    func render(results: (MoviesListContent, MovieImageInfo)) {
        if results.0.information.results.count == 0 {
            similarMoviesStackView.removeFromSuperview()
        } else {
            similarMoviesStackView.update(content: results.0)
        }

        if results.1.posters.count != 0 || results.1.backdrops.count != 0 {
            movieDetailsImageView.render(results: results.1)
        }
    }
    
    func startLoading(loading: Bool) {
        if loading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}
