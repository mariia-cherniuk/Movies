//
//  MoviesListViewController.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {

    private let movieListView = MoviesListView(frame: .zero)
    private let moviesViewModel: MoviesViewModel
    
    init(moviesViewModel: MoviesViewModel) {
        self.moviesViewModel = moviesViewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life Cycle
    override func loadView() {
        self.view = movieListView
        
        movieListView.didSelectItem = { item in
            self.moviesViewModel.showMovieDetails(movie: item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
    }
    
    deinit {
        print("💀", self)
    }
}

//MARK: Helpers
extension MoviesListViewController {
    private func loadData() {
        moviesViewModel.didStartLoading = movieListView.startLoading
        moviesViewModel.didLoadMovies = movieListView.render
        moviesViewModel.didFail = { [weak self] error in
            self?.showAlert(error: error)
        }
        
        moviesViewModel.loadMovies()
    }
    
    private func showAlert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] (action) in
            self?.moviesViewModel.loadMovies()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
