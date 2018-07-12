//
//  Movie.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

struct MoviesListContent {
    let title: String
    let information: MovieInfo
}

struct MovieInfo: Decodable {
    let page: Int
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let genreIds: [Int]
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    let popularity: Double?
    let title: String
    let voteAverage: Double
}

struct MovieImageInfo: Decodable {
    let backdrops: [MovieImage]
    let posters: [MovieImage]
}

struct MovieImage: Decodable {
    let filePath: String
    let width: Int
    let height: Int
    let aspectRatio: Double
}
