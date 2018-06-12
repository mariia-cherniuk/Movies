//
//  ViewController.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inTheatreCollectionView: UICollectionView!
    @IBOutlet weak var popularMoviesCollectionView: UICollectionView!
    @IBOutlet weak var highestRatedMoviesCollectionView: UICollectionView!
    
    private let moviewCollectionViewDelegate = MoviesCollectionViewDelegate<Movie>()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.configureInTheatreCollectionView()
        self.configureMoviewCollectionViewDelegate()
    }
    
    private func loadData() {
        let dataLoader = DataLoader()
        let remoteListRepository = RemoteListRepository<MovieInfo>(loader: dataLoader)
        let modelView = MoviesViewModel(listRepository: remoteListRepository)
        
        modelView.loadMovies()
        modelView.didLoadMovies = { [weak self] (moviesInfo) in
            if let movies = moviesInfo?.results {
                self?.render(movies: movies)
            }
        }
    }
    
    private func configureInTheatreCollectionView() {
        inTheatreCollectionView.delegate = moviewCollectionViewDelegate
        inTheatreCollectionView.dataSource = moviewCollectionViewDelegate
        
        inTheatreCollectionView.registerWithClass(MovieCollectionViewCell.self)
    }
    
    private func configureMoviewCollectionViewDelegate() {
        moviewCollectionViewDelegate.cellForItem = { collectionView, indexPath, item in
            return self.movieCollectionViewCell(collectionView: collectionView, indexPath: indexPath, movie: item)
        }
        moviewCollectionViewDelegate.sizeForItemAt = {
            return CGSize(width: 150, height: 250)
        }
    }
}

//MARK: Helpers
extension ViewController {
    private func movieCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        if let posterPath = movie.posterPath {
            cell.posterImageView.downloadImageFrom(path: posterPath)
        }
        
        return cell
    }

    private func render(movies: [Movie]) {
        moviewCollectionViewDelegate.update(items: movies)
        inTheatreCollectionView.reloadData()
    }
}
