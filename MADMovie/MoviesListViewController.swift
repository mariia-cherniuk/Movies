//
//  MoviesListViewController.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {

    private let movieListView: UIView & MoviesListViewProtocol = MoviesListView(frame: .zero)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "N E T F L I X"
        
        self.loadData()
    }
    
    private func loadData() {        
        moviesViewModel.loadMovies()
        
        moviesViewModel.didLoadMovies = movieListView.render
        moviesViewModel.didFail = { error in
            print(error)//TODO
        }
    }
}
