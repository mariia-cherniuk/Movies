//
//  MovieDetailsViewController.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    private let movieDetailsView = MovieDetailsView(frame: .zero)
    private let movieDetailsViewModel: MovieDetailsViewModel

    init(movieDetailsViewModel: MovieDetailsViewModel) {
        self.movieDetailsViewModel = movieDetailsViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life Cycle
    override func loadView() {
        self.view = movieDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureMovieDetailsView()
        self.loadData()
    }
    
    deinit {
        print("💀", self)
    }
}

//MARK: Helpers
extension MovieDetailsViewController {
    private func configureMovieDetailsView() {
        movieDetailsView.configureViews(movie: movieDetailsViewModel.movie)
        movieDetailsView.didSelectItem = movieDetailsViewModel.showMovieDetails
    }
    
    private func loadData() {
        movieDetailsViewModel.didStartLoading = movieDetailsView.startLoading
        movieDetailsViewModel.didLoadMovies = movieDetailsView.render(results:)
        
        movieDetailsView.movieDetailsImageView.didTapAllImagesButton = movieDetailsViewModel.showMovieImages
        movieDetailsViewModel.didFail = { [weak self] error in
            self?.showAlert(error: error)
        }
        
        movieDetailsViewModel.loadSimilarMovies()
    }
    
    private func showAlert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
