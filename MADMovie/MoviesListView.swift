//
//  MoviesListView.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

protocol MoviesListViewProtocol {
    func render(results: [MoviesListContent])
}

class MoviesListView: UIView {
    
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    private let inTheatreStackView = MoviesStackView()
    private let popularMoviesStackView = MoviesStackView()
    private let highestRatedMoviesStackView = MoviesStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureSubviesw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Configure UI
extension MoviesListView {
    private func configureSubviesw() {
        self.configureScrollView()
        self.configureMoviesStackViews()
        self.configureMainStackView()
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    private func configureMoviesStackViews() {
        inTheatreStackView.heightAnchor.constraint(equalToConstant: 260).isActive = true
    }
    
    private func configureMainStackView() {
        mainStackView.addArrangedSubview(inTheatreStackView)
        mainStackView.addArrangedSubview(popularMoviesStackView)
        mainStackView.addArrangedSubview(highestRatedMoviesStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        
        scrollView.addSubview(mainStackView)
        
        mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}

//MARK: MoviesListViewProtocol
extension MoviesListView: MoviesListViewProtocol {
    func render(results: [MoviesListContent]) {
        inTheatreStackView.update(content: results[0])
        popularMoviesStackView.update(content: results[1])
        highestRatedMoviesStackView.update(content: results[2])
    }
}
