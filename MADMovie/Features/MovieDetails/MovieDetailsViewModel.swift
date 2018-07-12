//
//  MovieDetailsViewModel.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

class MovieDetailsViewModel {
    private let remoteListRepository: RemoteListRepository<MovieInfo>
    private let imagesRemoteListRepository: RemoteListRepository<MovieImageInfo>
    private let appNavigator: AppNavigator
    private var movieImage: MovieImageInfo?
    let movie: Movie
    
    var didLoadMovies: (((MoviesListContent, MovieImageInfo)) -> Void)?
    var didFail: ((Error) -> Void)?
    var didStartLoading: ((Bool) -> Void)?
    
    init(appNavigator: AppNavigator, listRepository: RemoteListRepository<MovieInfo>, imagesRemoteListRepository: RemoteListRepository<MovieImageInfo>, movie: Movie) {
        self.imagesRemoteListRepository = imagesRemoteListRepository
        self.remoteListRepository = listRepository
        self.appNavigator = appNavigator
        self.movie = movie
    }
    
    func loadSimilarMovies() {
        let dispatchGroup = DispatchGroup()
        var similarMoviesResult: Result<MovieInfo>?
        var movieImagesResult: Result<MovieImageInfo>?
        
        didStartLoading?(true)
        
        dispatchGroup.enter()
        remoteListRepository.getAll(request: SimilarMoviesRequest(movieID: movie.id)) { (result) in
            similarMoviesResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        imagesRemoteListRepository.getAll(request: MovieImagesRequest(movieID: movie.id)) { (result) in
            movieImagesResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            let combined = Result<(MovieInfo, MovieImageInfo)>.combine(r1: similarMoviesResult!, r2: movieImagesResult!, selector: { (info1, info2) in
                return (info1, info2)
            })

            self.didStartLoading?(false)
            
            switch combined {
            case .failure(let error):
                self.didFail?(error)
            case .success(let result):
                let similarMovies = MoviesListContent(title: "MORE LIKE THIS", information: result.0)
                self.movieImage = result.1
             
                self.didLoadMovies?((similarMovies, self.movieImage!))
            }
        }
    }

    func showMovieDetails(movie: Movie) {
        appNavigator.navigate(to: .movieDetails(movie: movie))
    }
    
    func showMovieImages() {
        guard let unwrappedMovieImage = movieImage else { return }
        var images = unwrappedMovieImage.backdrops + unwrappedMovieImage.posters
        
        images.shuffle()
        
        appNavigator.navigate(to: .moviesImages(images: images))
    }
}
