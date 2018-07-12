//
//  MovieImagesView.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class MovieImagesView: UIView {
    private let imagesCollectionView: UICollectionView
    private let collectionViewDelegate = ArrayCollectionViewAdapter<MovieImage>()
    
    init(frame: CGRect, layoutDelegate: LayoutAdapter) {
        let layout = MosaicLayout(layoutDelegate: layoutDelegate, numberOfColumns: 2, spacing: 5)
        
        self.imagesCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        super.init(frame: frame)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Configure UI
extension MovieImagesView {
    private func configureSubviews() {
        self.configureCollectionViewDelegate()
        self.configureImagesCollectionView()
    }
    
    private func configureCollectionViewDelegate() {
        collectionViewDelegate.cellForItem = { collectionView, indexPath, movieBackdrop in
            return self.movieCollectionViewCell(collectionView: collectionView, indexPath: indexPath, movieBackdrop: movieBackdrop)
        }
        collectionViewDelegate.sizeForItemAt = { item in
            return CGSize(width: self.bounds.width/2.1, height: self.bounds.width/2.1)
        }
    }
    
    private func configureImagesCollectionView() {
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imagesCollectionView.delegate = collectionViewDelegate
        imagesCollectionView.dataSource = collectionViewDelegate
        imagesCollectionView.registerWithClass(MovieCollectionViewCell.self)
        
        self.addSubview(imagesCollectionView)
        
        imagesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imagesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imagesCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imagesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func movieCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, movieBackdrop: MovieImage) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        cell.loadImage(posterPath: movieBackdrop.filePath)
        
        return cell
    }
    
    func updateCollection(results: [MovieImage]) {
        collectionViewDelegate.update(items: results)
        imagesCollectionView.reloadData()
    }
}
