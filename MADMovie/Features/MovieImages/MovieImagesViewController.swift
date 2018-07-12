//
//  MovieImagesViewController.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

protocol LayoutAdapter: AnyObject {
    func heightForPhoto(indexPath: IndexPath, width: CGFloat) -> CGFloat
}

class MovieImagesViewController: UIViewController {
    private var movieImagesView: MovieImagesView?
    private let images: [MovieImage]
    
    init(images: [MovieImage]) {
        self.images = images
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieImagesView = MovieImagesView(frame: .zero, layoutDelegate: self)
        
        self.view = movieImagesView
        self.configureMovieImagesView()
    }
    
    deinit {
        print("💀", self)
    }
}

//MARK: Helpers
extension MovieImagesViewController {
    private func configureMovieImagesView() {
        movieImagesView?.updateCollection(results: images)
    }
}

extension MovieImagesViewController: LayoutAdapter {
    func heightForPhoto(indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return CGFloat(width / CGFloat(images[indexPath.row].aspectRatio))
    }
}
