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
    
    static func combine<T, U, V>(r1: Result<T>, r2: Result<U>, selector: (T, U) -> V) -> Result<V> {
        switch (r1, r2) {
        case let (.success(a), .success(b)):
            return Result<V>.success(selector(a, b))
        case (.failure(let error), _):
            return Result<V>.failure(error)
        case (_, .failure(let error)):
            return Result<V>.failure(error)
        }
    }
}

protocol DataLoaderProtocol {
    func loadData(urlRequest: URLRequest, completion: @escaping (Result<Data>) -> Void)
}

class DataLoader : DataLoaderProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func loadData(urlRequest: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
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
