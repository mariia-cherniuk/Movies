//
//  ViewModel.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

class MoviesViewModel {
    
    private let remoteListRepository: RemoteListRepository<MovieInfo>
    private let appNavigator: AppNavigator
    
    var didLoadMovies: (([MoviesListContent]) -> Void)?
    var didFail: ((Error) -> Void)?
    var didStartLoading: ((Bool) -> Void)?
    
    init(appNavigator: AppNavigator, listRepository: RemoteListRepository<MovieInfo>) {
        self.remoteListRepository = listRepository
        self.appNavigator = appNavigator
    }
    
    func loadMovies() {
        let dispatchGroup = DispatchGroup()
        var popularMoviesResult: Result<MovieInfo>?
        var inTheatreResult: Result<MovieInfo>?
        var highestRatedMoviesResult: Result<MovieInfo>?
        
        didStartLoading?(true)
        
        dispatchGroup.enter()
        self.listRequest(request: InTheatreRequest()) { (result) in
            popularMoviesResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.listRequest(request: PopularityRequest()) { (result) in
            inTheatreResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.listRequest(request: HighestRatedMoviesRequest()) { (result) in
            highestRatedMoviesResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            let combined =  Result<[MovieInfo]>.combine(r1: popularMoviesResult!, r2: inTheatreResult!, r3: highestRatedMoviesResult!, selector: { (info1, info2, info3) in
                return [info1, info2, info3]
            })
            
            self.didStartLoading?(false)
            
            switch combined {
            case .failure(let error):
                self.didFail?(error)
            case .success(let movies):
                let info1 = MoviesListContent(title: "What are the most popular movies?", information: movies[0])
                let info2 = MoviesListContent(title: "What movies are in theatres?", information: movies[1])
                let info3 = MoviesListContent(title: "What are the highest rated movies?", information: movies[2])
                
                self.didLoadMovies?([info1, info2, info3])
            }
        }
    }
    
    private func listRequest(request: RequestConvertible, completion: @escaping ((Result<MovieInfo>) -> Void)) {
        remoteListRepository.getAll(request: request) { (result) in
            completion(result)
        }
    }
    
    func showMovieDetails(movie: Movie) {
        appNavigator.navigate(to: .movieDetails(movie: movie))
    }
}
