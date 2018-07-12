//
//  MoviesStackView.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class MoviesStackView: UIView {
    private let layout = UICollectionViewFlowLayout()
    private lazy var moviesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    private let mainStackView = UIStackView()
    private let titleLabel = UILabel()
    
    private let collectionViewDelegate = ArrayCollectionViewAdapter<Movie>()
    
    var didSelectItem: ((Movie) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Configure UI
extension MoviesStackView {
    private func configureSubviews() {
        self.configureTitleLabel()
        self.configureCollectionViewDelegate()
        self.configureMoviesCollectionView()
        self.configureMainStackView()
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 17)!
        titleLabel.textColor = UIColor.white
    }
    
    private func configureCollectionViewDelegate() {
        collectionViewDelegate.cellForItem = { collectionView, indexPath, item in
            return self.movieCollectionViewCell(collectionView: collectionView, indexPath: indexPath, movie: item)
        }
        collectionViewDelegate.sizeForItemAt = { item in
            return CGSize(width: 130, height: 220)
        }
        collectionViewDelegate.didSelectItem = { item in
            self.didSelectItem?(item)
        }
    }
    
    private func configureMoviesCollectionView() {
        layout.scrollDirection = .horizontal
        moviesCollectionView.delegate = collectionViewDelegate
        moviesCollectionView.dataSource = collectionViewDelegate
        moviesCollectionView.registerWithClass(MovieCollectionViewCell.self)
    }
    
    private func configureMainStackView() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(moviesCollectionView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        
        self.addSubview(mainStackView)
        
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}

//MARK: Helpers
extension MoviesStackView {
    private func movieCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        if let posterPath = movie.posterPath {
            cell.loadImage(posterPath: posterPath)
        }
        
        return cell
    }
    
    func update(content: MoviesListContent) {
        collectionViewDelegate.update(items: content.information.results)
        titleLabel.text = content.title
        
        moviesCollectionView.reloadData()
    }
}
