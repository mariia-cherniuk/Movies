//
//  MovieDetailsImageView.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

final class MovieDetailsImageView: UIView {
    
    private let layout = UICollectionViewFlowLayout()
    private lazy var backdropsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    private let collectionViewDelegate = ArrayCollectionViewAdapter<MovieImage>()
    private let posterImageView = MovieImageView()
    private let allImagesButton = UIButton()

    var didTapAllImagesButton: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Configure UI
extension MovieDetailsImageView {
    private func configureSubviews() {
        self.backgroundColor = UIColor.black
        
        self.configureCollectionViewDelegate()
        self.configureBackdropsCollectionView()
        self.configureAllImagesButton()
        self.configurePosterImageView()
    }
    
    private func configureCollectionViewDelegate() {
        collectionViewDelegate.cellForItem = { collectionView, indexPath, movieBackdrop in
            return self.movieCollectionViewCell(collectionView: collectionView, indexPath: indexPath, movieBackdrop: movieBackdrop)
        }
        collectionViewDelegate.sizeForItemAt = { item in
            return CGSize(width: self.bounds.width, height: 230)
        }
        collectionViewDelegate.minimumLineSpacingForSection = {
            return 0
        }
    }
    
    private func configureBackdropsCollectionView() {
        backdropsCollectionView.isPagingEnabled = true
        backdropsCollectionView.translatesAutoresizingMaskIntoConstraints = false
       
        layout.scrollDirection = .horizontal
        backdropsCollectionView.delegate = collectionViewDelegate
        backdropsCollectionView.dataSource = collectionViewDelegate
        backdropsCollectionView.registerWithClass(MovieCollectionViewCell.self)
        
        self.addSubview(backdropsCollectionView)
        
        backdropsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backdropsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backdropsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backdropsCollectionView.heightAnchor.constraint(equalToConstant: 230).isActive = true
    }
    
    private func configureAllImagesButton() {
        allImagesButton.isEnabled = false
        allImagesButton.translatesAutoresizingMaskIntoConstraints = false
        allImagesButton.addTarget(self, action: #selector(allImagesButtonPressed), for: .touchUpInside)
        
        self.addSubview(allImagesButton)
        
        allImagesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        allImagesButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        allImagesButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        allImagesButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configurePosterImageView() {
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.image = UIImage(named: "default_poster_icon")
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(posterImageView)
        
        posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 85).isActive = true
    }
}

//MARK: Helpers
extension MovieDetailsImageView {
    private func movieCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, movieBackdrop: MovieImage) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        cell.loadImage(posterPath: movieBackdrop.filePath)
        
        return cell
    }
    
    func configureImageViews(posterPath: String?) {
        if let posterPath = posterPath {
            posterImageView.downloadImageFrom(path: posterPath)
        }
    }
    
    func render(results: MovieImageInfo) {
        allImagesButton.setTitle("SHOW ALL", for: .normal)
        allImagesButton.isEnabled = true
        
        collectionViewDelegate.update(items: results.backdrops)
        backdropsCollectionView.reloadData()
    }
    
    @objc private func allImagesButtonPressed() {
        didTapAllImagesButton?()
    }
}
