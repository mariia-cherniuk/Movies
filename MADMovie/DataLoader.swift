//
//  DataLoader.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

enum LoadingError: Swift.Error {
    case unknown
}

enum Result<T> {
    case success(T)
    case failure(Error)
    
    init(closure: () throws -> T) {
        do {
            self = .success(try closure())
        } catch {
            self = .failure(error)
        }
    }
}

protocol DataLoaderProtocol {
    func loadData(urlRequest: URLRequest, completion: @escaping (Result<Data>) -> Void)
}

class DataLoader : DataLoaderProtocol {
    func loadData(urlRequest: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(Result.failure(error))
            } else if let data = data {
                completion(Result.success(data))
            } else {
                completion(Result.failure(LoadingError.unknown))
            }
        }
        
        dataTask.resume()
    }
}
