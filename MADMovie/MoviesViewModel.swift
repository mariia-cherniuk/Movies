//
//  ViewModel.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

class MoviesViewModel {
    
    private let remoteListRepository: RemoteListRepository<MovieInfo>
    
    var didLoadMovies: ((MovieInfo?) -> Void)?
    var didFail: ((Error) -> Void)?
    
    init(listRepository: RemoteListRepository<MovieInfo>) {
        remoteListRepository = listRepository
    }
    
    func loadMovies() {
        let moviesRequest = PopularityRequest().request()
        
        remoteListRepository.getAll(request: moviesRequest) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.didFail?(error)
                case .success(let movies):
                    self.didLoadMovies?(movies)
                }
            }
        }
    }
}
