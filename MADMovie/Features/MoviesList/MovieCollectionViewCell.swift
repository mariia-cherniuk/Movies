//
//  MovieCollectionViewCell.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    private let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self.addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        // TODO: Cancel image loading
    }
    
    private func addSubviews() {
        posterImageView.contentMode = .scaleAspectFill
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
    func loadImage(posterPath: String, service: MovieImageService) {
        service.loadPoster(with: posterPath) { (image) in
            self.posterImageView.image = image
        }
    }
}
