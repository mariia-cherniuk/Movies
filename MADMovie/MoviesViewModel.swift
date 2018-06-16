//
//  ViewModel.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

class MoviesViewModel {
    
    private let remoteListRepository: RemoteListRepository<MovieInfo>
    
    var didLoadMovies: (([MoviesListContent]) -> Void)?
    var didFail: ((Error) -> Void)?
    
    init(listRepository: RemoteListRepository<MovieInfo>) {
        remoteListRepository = listRepository
    }
    
    func loadMovies() {
        let dispatchGroup = DispatchGroup()
        var popularMoviesResult: Result<MovieInfo>?
        var inTheatreResult: Result<MovieInfo>?
        var highestRatedMoviesResult: Result<MovieInfo>?
        
        dispatchGroup.enter()
        self.popularityRequest(request: InTheatreRequest()) { (result) in
            popularMoviesResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.popularityRequest(request: PopularityRequest()) { (result) in
            inTheatreResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.popularityRequest(request: HighestRatedMoviesRequest()) { (result) in
            highestRatedMoviesResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            let combined =  Result<[MovieInfo]>.combine(r1: popularMoviesResult!, r2: inTheatreResult!, r3: highestRatedMoviesResult!, selector: { (info1, info2, info3) in
                return [info1, info2, info3]
            })
            
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
    
    private func popularityRequest(request: RequestConvertible,completion: @escaping ((Result<MovieInfo>) -> Void)) {
        remoteListRepository.getAll(request: request.request()) { (result) in
            completion(result)
        }
    }
}
