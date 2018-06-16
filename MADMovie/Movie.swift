//
//  Movie.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

struct MoviesListContent {
    let title: String
    let information: MovieInfo
}

struct MovieInfo: Decodable {
    let page: Int
    let results: [Movie]
}

struct Movie: Decodable {
    let genreIds: [Int]
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let popularity: Double
    let title: String
    let voteAverage: Double
}
