//
//  RequestConvertible.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

protocol RequestConvertible {
    func request() -> URLRequest
}

extension RequestConvertible {
    var scheme: String {
        return "https"
    }
    var host: String {
        return "api.themoviedb.org"
    }
    var path: String {
        return "/3/discover/movie"
    }
    var components: URLComponents {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: "d4f0bdb3e246e2cb3555211e765c89e3")]
        
        return urlComponents
    }
}

struct PopularityRequest: RequestConvertible {
    func request() -> URLRequest {
        var components = self.components
        components.queryItems?.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
        let url = components.url!
        
        return URLRequest(url: url)
    }
}

struct InTheatreRequest: RequestConvertible {
    func request() -> URLRequest {
        var components = self.components
        let startDate = Date().previousMonthString()
        let endDate = Date().stringDate()
        
        components.queryItems?.append(URLQueryItem(name: "primary_release_date.gte", value: startDate))
        components.queryItems?.append(URLQueryItem(name: "primary_release_date.lte", value: endDate))
        
        let url = components.url!
        
        return URLRequest(url: url)
    }
}

struct HighestRatedMoviesRequest: RequestConvertible {
    func request() -> URLRequest {
        var components = self.components
        
        components.queryItems?.append(URLQueryItem(name: "certification_country", value: "US"))
        components.queryItems?.append(URLQueryItem(name: "certification", value: "R"))
        components.queryItems?.append(URLQueryItem(name: "sort_by", value: "vote_average.desc"))

        let url = components.url!
        
        return URLRequest(url: url)
    }
}

struct PosterRequest {
    func request(posterPath: String) -> URLRequest {
        let stringURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
        let url = URL(string: stringURL)
        
        return URLRequest(url: url!)
    }
}
