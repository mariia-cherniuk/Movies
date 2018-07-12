//
//  AppNavigator.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

enum Route {
    case moviesList
    case movieDetails(movie: Movie)
    case moviesImages(images: [MovieImage])
}

protocol AppNavigatorProtocol {
    func navigate(to appFlow: Route)
}

final class AppNavigator: AppNavigatorProtocol {
    private var navigationController: UINavigationController?
    private let dataLoader = DataLoader(urlSession: URLSession.shared)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func navigate(to appFlow: Route) {
        guard let viewController = self.destinationViewController(for: appFlow) else { return }
        
        viewController.title = "M O V I E S"
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: Helpers
extension AppNavigator {
    private func destinationViewController(for flow: Route) -> UIViewController? {
        switch flow {
        case .moviesList:
            return self.moviesListViewController()
        case .movieDetails(let movie):
            return self.movieDetailsViewController(movie: movie)
        case .moviesImages(let images):
            return self.moviesMovieImagesViewController(images: images)
        }
    }
    
    private func moviesListViewController() -> UIViewController {
        let remoteListRepository = RemoteListRepository<MovieInfo>(loader: dataLoader)
        let viewModel = MoviesViewModel(appNavigator: self, listRepository: remoteListRepository)
        let viewController = MoviesListViewController(moviesViewModel: viewModel)
        
        return viewController
    }
    
    private func movieDetailsViewController(movie: Movie) -> UIViewController {
        let remoteListRepository = RemoteListRepository<MovieInfo>(loader: dataLoader)
        let imagesRemoteListRepository = RemoteListRepository<MovieImageInfo>(loader: dataLoader)
        let viewModel = MovieDetailsViewModel(appNavigator: self, listRepository: remoteListRepository, imagesRemoteListRepository: imagesRemoteListRepository, movie: movie)
        let viewController = MovieDetailsViewController(movieDetailsViewModel: viewModel)
        
        return viewController
    }
    
    private func moviesMovieImagesViewController(images: [MovieImage]) -> UIViewController {
        let viewController = MovieImagesViewController(images: images)
        
        return viewController
    }
}
