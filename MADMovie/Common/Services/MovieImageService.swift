//
//  MovieImageService.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

protocol ImageServiceProtocol {
    func loadPoster(with path: String, callback: @escaping (UIImage) -> Void)
    func cancelLoad(for path: String)
}

final class MovieImageService: ImageServiceProtocol {
    private let cache: ImageCache
    private let loader: DataLoaderProtocol
    private var tasks: [String: Cancelable] = [:]
    
    init(cache: ImageCache, loader: DataLoaderProtocol) {
        self.cache = cache
        self.loader = loader
    }
    
    func loadPoster(with path: String, callback: @escaping (UIImage) -> Void) {
        let request = PosterRequest(posterPath: path)
        if let image = cache.image(forKey: path) {
            callback(image)
            return
        }
        tasks[path] = loader.loadData(urlRequest: request) { (result) in
            DispatchQueue.main.async {
                if let data = result.value, let image = UIImage(data: data) {
                    self.cache.add(image: image, key: path)
                    callback(image)
                }
            }
        }
    }
    
    func cancelLoad(for path: String) {
        tasks[path]?.cancel()
    }
}
