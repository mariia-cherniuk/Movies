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
    
    static func combine<T, U, V, R>(r1: Result<T>, r2: Result<U>, r3: Result<V>, selector: (T, U, V) -> R) -> Result<R> {
        switch (r1, r2, r3) {
        case let (.success(a), .success(b), .success(c)):
            return Result<R>.success(selector(a, b, c))
        case (.failure(let error), _, _):
            return Result<R>.failure(error)
        case (_, .failure(let error), _):
            return Result<R>.failure(error)
        case (_, _, .failure(let error)):
            return Result<R>.failure(error)
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
