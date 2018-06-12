//
//  ListRepository.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

protocol ListRepository {
    associatedtype T
    
    func getAll(request: URLRequest, completion: @escaping (Result<T>) -> Void)
}

final class RemoteListRepository<T: Decodable>: ListRepository {
    let dataLoader: DataLoaderProtocol
    
    init(loader: DataLoaderProtocol) {
        dataLoader = loader
    }
    
    func getAll(request: URLRequest, completion: @escaping (Result<T>) -> Void) {
        dataLoader.loadData(urlRequest: request) { (result) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(let data):
                let result = Result(closure: { () -> T in 
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                })
                
                completion(result)
            }
        }
    }
}
