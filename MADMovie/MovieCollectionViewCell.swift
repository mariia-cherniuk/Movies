//
//  MovieCollectionViewCell.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

protocol MovieCollectionViewCellProtocol {
    func loadImage(posterPath: String)
}

class MovieCollectionViewCell: UICollectionViewCell, MovieCollectionViewCellProtocol {
    
    private let posterImageView = MovieImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(posterImageView)
        self.configurePosterImageView()
    }
    
    private func configurePosterImageView() {
        posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    //MARK: MovieCollectionViewCellProtocol
    func loadImage(posterPath: String) {
        posterImageView.downloadImageFrom(path: posterPath)
    }
}
