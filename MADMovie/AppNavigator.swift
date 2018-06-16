//
//  AppNavigator.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

enum AppFlow {
    case MoviesList,
    MovieDetails
}

protocol AppNavigatorProtocol {
    func navigate(to appFlow: AppFlow)
}

final class AppNavigator: AppNavigatorProtocol {
    private var navigationController: UINavigationController?
    private let dataLoader = DataLoader()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(to appFlow: AppFlow) {
        guard let viewController = self.destinationViewController(for: appFlow) else { return }
        
        navigationController?.pushViewController(viewController, animated: false)
    }
}

//MARK: Helpers
extension AppNavigator {
    private func destinationViewController(for flow: AppFlow) -> UIViewController? {
        switch flow {
        case .MoviesList:
            return self.moviesListViewController()
        case .MovieDetails:
            return self.movieDetailsViewController()
        }
    }
    
    private func moviesListViewController() -> UIViewController {
        let remoteListRepository = RemoteListRepository<MovieInfo>(loader: dataLoader)
        let viewModel = MoviesViewModel(listRepository: remoteListRepository)
        let viewController = MoviesListViewController(moviesViewModel: viewModel)
        
        return viewController
    }
    
    private func movieDetailsViewController() -> UIViewController {
        return UIViewController()//TODO
    }
}
