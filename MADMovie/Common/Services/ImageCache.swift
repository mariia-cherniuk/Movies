//
//   ImageCache.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

protocol ImageCacheProtocol {
    func add(image: UIImage, key: String)
    func image(forKey key: String) -> UIImage?
}

class ImageCache: ImageCacheProtocol {
    private let imageCache = NSCache<NSString, UIImage>()
    
    //MARK: ImageCacheProtocol
    func add(image: UIImage, key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}
