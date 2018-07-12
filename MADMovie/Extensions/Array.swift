//
//  Array.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for _ in 0..<count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
